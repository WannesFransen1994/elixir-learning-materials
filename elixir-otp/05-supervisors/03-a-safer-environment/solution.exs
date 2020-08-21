workers = [A, B, C]
supervisor = SUP

defmodule Employee do
  use GenServer

  def start_link(name: n), do: GenServer.start_link(__MODULE__, 0, name: n)
  def init(work) when is_integer(work), do: {:ok, %{work: 0}, {:continue, :start}}
  def add_work(emp, amount), do: GenServer.cast(emp, {:addwork, amount})

  def handle_cast({:addwork, n}, s), do: {:noreply, %{s | work: s.work + n}}

  def handle_info(:boom, state) do
    {:stop, :shutdown, state}
  end

  def handle_info(:work, %{work: 0} = s) do
    Process.send_after(self, :work, 1000)
    {:noreply, s}
  end

  def handle_info(:work, %{work: w} = s) do
    Process.send_after(self, :work, 1000)
    IO.puts("#{inspect(self())} decreased work to: #{s.work - 1}")
    {:noreply, %{s | work: w - 1}}
  end

  def handle_continue(:start, state) do
    Process.send_after(self, :work, 1000)
    {:noreply, state}
  end

  def terminate(reason, %{work: n}) do
    children = Supervisor.which_children(SUP)

    other_pids =
      Enum.reduce(children, [], fn {_, pid, _, _}, acc ->
        cond do
          self() != pid -> [pid | acc]
          true -> [pid | acc]
        end
      end)

    Enum.each(other_pids, &Employee.add_work(&1, div(n, length(other_pids) - 1)))
    {:stop, reason}
  end
end

children = Enum.map(workers, &Supervisor.child_spec({Employee, [name: &1]}, id: &1))

opts = [strategy: :one_for_one, name: supervisor]
Supervisor.start_link(children, opts)

# Verify that everything is running
Enum.all?([supervisor | workers], &(Process.whereis(&1) != nil))

Employee.add_work(A, 5000)
send(A, :boom)
