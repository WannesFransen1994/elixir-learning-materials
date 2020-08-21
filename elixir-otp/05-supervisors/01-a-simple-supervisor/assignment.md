# Assignment

We're going to emulate a dangerous working environment where explosives have to be processed. Let's say that every explosive takes 1s to process and we have 3 employees.

Create a simple worker process and supervisor that:

* When it receives a tuple containing {:assign_work, number}, he/she should start working. Note that in between the work, the employee should be able to receive even more work. That's life.
* For now let's make a naive implementation that when an explosive blows up, all the work he/she has to do is lost. Immediately a new employee is hired to replace the old one. This can be emulated with sending the message `:boom`.

Constraints:

* Use a `GenServer` to write the `Employee` module.
* Use a normal Supervisor.
* When one process dies, others aren't affected. Verify this by giving another worker work, while sending `:boom` to another worker.

## A schematic overview

```text
    I           => your iex shell
    |           => bidirectional link
    S           => your supervisor
    |\
    | \         => All bidirectional links
    |\ \___ EA  => Employee A
    | \____ EB  => Employee B
     \_____ EC  => Employee C
```

## Some hints

### GenServer and bidirectional links

This will most likely lead to following boilerplate code:

```elixir
defmodule Employee do
  use GenServer

  def start_link(args), do: GenServer.start_link(__MODULE__, init_args, name: [NAME])
  def init(args), do: {:ok, starting_state} # {:continue, :to_be_matched_upon} could be the 3rd element of the tuple
end
```

As you saw with processes (exercise 10 - encapsulating) and in the GenServer exercises, making an API to handle asynchronous (or synchronous, but that's not the case here) is common. That'll probably lead to something like:

```elixir
defmodule Employee do
  ...

  def add_work(emp, amount), do: GenServer.cast(emp, {:addwork, amount})
  def handle_cast({:addwork, n}, s), do: {:noreply, newstate}
end
```
