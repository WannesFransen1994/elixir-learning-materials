################################################################
# Example 1: Simple factorials calculator + naive benchmarking #
################################################################

defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

defmodule Factorials do
  def calculate(n), do: calculate(n, 1)
  def calculate(1, acc), do: acc
  def calculate(n, acc), do: calculate(n - 1, acc * n)
end

fn -> Factorials.calculate(50_000) end |> Benchmark.measure()

########################################################
# Example 2: keep checking up until a task is complete #
########################################################

defmodule MyTaskChecker do
  # This is a constant
  @timeout = 3_000

  def check(%Task{} = t) do
    IO.puts("Start periodic checking for task with PID #{inspect(t.pid)}")
    report(t, nil)
  end

  # Note the second parameter: this clause catches
  # cases where the result is missing (= due to timeout)
  defp report(%Task{} = t, nil) do
    IO.puts("Checking...")
    # Returns nil on timeout
    result = Task.yield(t, @timeout)
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

#############################################################
# Example 3: anynchronous task processing with a time limit #
#############################################################

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
