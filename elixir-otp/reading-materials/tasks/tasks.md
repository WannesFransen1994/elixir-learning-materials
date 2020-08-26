# Tasks

_We are using terminology normally used in the Erlang / Elixir context. When we talk about OS-related terminology, we will specifically mention this._

## Tasks vs processes

Tasks are an abstraction of normal processes, meant to easily execute asynchronous compute-intensive operations and await their response.

They normally require no communication, and also provide a useful API to do different operations.

## An asynchronous task with a reply

There are different kinds of tasks, but let us start with the most basic form: a task that gives a response.

### Context: factorials

Let us start with a very simple factorial module.

```elixir
defmodule Factorials do
    def calculate(n), do: calculate(n, 1)
    def calculate(1, acc), do: acc
    def calculate(n, acc), do: calculate(n - 1, acc * n)
end
```

_We'll use a benchmark module which will be explained later on._

Calculating the factorial of 50,000 will take a while: on my system it takes 1.7s. Imagine that we offer a platform/API to calculate one or more factorials at the same time. The user gives a set of numbers (e.g., in a web browser), then has to wait until all the factorials have been calculated synchronously. This will take a unnecessarily large amount of time. We can improve on this by performing the task *asynchronously*. Note that these asynchronous tasks have no need to communicate with each other (i.e., each computation is independent of the others and they
don't rely on each other's results), which is the easiest form of asynchronous computing.

### `Task.async` and `Task.await`

First let us start a tedious task:

```elixir
iex(1)> t =
...(1)>   Task.async(fn ->
...(1)>     :timer.sleep(10_000) # Wait 10 seconds
...(1)>     "Returning hi"
...(1)>   end)
%Task{
  owner: #PID<0.105.0>,
  pid: #PID<0.111.0>,
  ref: #Reference<0.1392272653.3360948226.102954>
}
```

A short clarification:

* `%Task{...}` is a struct. This is just a bare map underneath. Operations such as `Map.get` or `Map.fetch` work without any problems.
* PID is the process identifier. If necessary, we can use this to send messages to the task.
* A reference is a special data type meant to be used as identifiers. They are often used to uniquely identify messages. Imagine for example a process that determines whether a number is prime. If you send it two numbers 5 and 10, it will answer with `true` and `false`. However, due to the asynchronous nature of the request, these answers can arrive in any order. It is therefore important to tag each response, so that you can know which answer corresponds to which question. References are an efficient way to achieve this.

In the end, the `Task` struct does nothing more than bundle a process with some
extra information into one data structure.

In the above task, which is just an example showing how we can collect output from a task, the last value emitted is "returning HI". This result can be collected with `Task.await(task)`:

```elixir
iex(2)> result = Task.await(t, 10_000)
"Returning hi"
```

The first argument is the task, the second is a timeout value.
`await` normally waits until the task has produced a result.
The timeout value (here 10 seconds) is an upper bound
on the waiting time: if the task has not produced a result
after 10 seconds, `await` will exit the current process.

An example use case would be that a user with malicious intentions inserts extremely high numbers in your Factorial calculation website in the hopes to crash your system, but thanks to the timeout you can define how many seconds one task is allowed to take.

Similarly to `Task.await`, `Task.yield` also allows you to wait for a task's result,
but instead of exiting the process on timeout, it will simply return `nil`. This allows you to periodically check if a task has finished.

#### Going in-depth with `Task.yield`

To demonstrate the usage and benefits of `Task.yield`, we'll write a module that executes specific code until the task is finished.

```elixir
defmodule MyTaskChecker do
  @timeout = 3_000      # This is a constant

  def check(%Task{} = t) do
    IO.puts("Start periodic checking for task with PID #{inspect(t.pid)}")
    report(t, nil)
  end

  # Note the second parameter: this clause catches
  # cases where the result is missing (= due to timeout)
  defp report(%Task{} = t, nil) do
    IO.puts("Checking...")
    result = Task.yield(t, @timeout) # Returns nil on timeout
    report(t, result)
  end

  defp report(_t, result), do: result
end

t =
  Task.async(fn ->
    :timer.sleep(20_000)
    "Finished"
  end)

MyTaskChecker.check(t)
```

`check`'s `%Task{} = t` parameter means that it's expected to be a `Task` struct. It essentially means "this parameter must satisfy the pattern `%Task{}` and we call it `t`." After that we print a quick message and start reporting. To get things started, `check` calls `report` with `nil`, which causes the first clause to be executed.

This code serves to illustrate a task that takes 20 seconds, which we check upon every 3 seconds. When we call `Task.yield` and there is no result after 3 seconds, it returns `nil`. In this case, the first `MyTaskChecker.report` clause matches, prints a message and tries `Task.yield` again. When it is finished it returns the result. To see this is in action:

```elixir
iex> MyTaskChecker.check(t)
Start periodic checking for task with PID #PID<0.406.0>
Checking...
Checking...
Checking...
Checking...
Checking...
Checking...
Checking...
{:ok, "Finished"}
```

As you can see, this is perfect to execute code while waiting for your task to finish.

## Building our factorial API

Let us build a simple wrapper around our `Factorial` module to allow us to calculate the factorials for a whole list, so that we can demonstrate the use of `Task.yield_many`.

Considering we already have most of our code (the logic) of our `FactorialAPI`, we can focus on the "interface" module. Though in order to protect our fictive server on which this code will run, we're going to provide a timeout based on the completion time of the complete list.

To put it into perspective, imagine a list with the elements
`[1,4,6,7,9,9999999999999999999999]`. We can immediately guess which factorials can be calculated within a given time frame, and which cannot. In this case, we'll just return the factorials of the elements which we can calculate within reasonable time and an error for those which are too large.

```elixir
defmodule FactorialAPI do
  def calculate_list(l) when is_list(l) do
    # Create list of tasks
    tasks = Enum.map(l, &Task.async(fn -> Factorials.calculate(&1) end))

    # Wait for as many tasks as possible, max. 2 seconds
    results = Task.yield_many(tasks, 2_000)

    # Deal with results
    Enum.map(results, &process_task_output/1)
  end

  # Clause for unfinished tasks: kill them
  defp process_task_output({t, nil}) do
    Task.shutdown(t, :brutal_kill)
    {:error, :timeout_exceeded}
  end

  # Clause for tasks having finished within time limit
  defp process_task_output({_t, {:ok, resp}}), do: resp
end
```

The `FactorialAPI` has one public entry point: the `calculate_list` function. We start a task for each number in the list, which are then collected by `Task.yield_many` with a timeout of 2 seconds. Every task in the list `tasks` will return a tuple consisting of `{ %Task{}, response }` where the first element is the `Task` struct and the second the response. The response can be either `{:ok, result}` or `nil`, the latter
being returned if the task has not completed within the given time limit.

Sample usage of this module would be:

```elixir
iex> FactorialAPI.calculate_list([1, 2, 3, 999_999_999_999])
[1, 2, 6, {:error, :timeout_exceeded}]
```

Here you can see that the `process_task_output` function pattern matches on the output. Keep in mind that if the task is still running, we have to kill it manually. That is what the `Task.shutdown` is for. The `:brutal_kill` argument is the exit signal.

_There are several exit signals. When using `Task.shutdown` you can also pass a timeout instead of the exit signal, which will send the :shutdown exit signal after the timeout. In our case, we don't want to wait and just kill it straight away. Hence the `:brutal_kill` argument._
