workers = [A, B, C]
supervisor = SUP

defmodule Employee do
  use GenServer

  def start_link(name: n), do: GenServer.start_link(__MODULE__, 0, name: n)
  def init(work) when is_integer(work), do: {:ok, %{work: 0}, {:continue, :start}}
  def add_work(emp, amount), do: GenServer.cast(emp, {:addwork, amount})

  def handle_cast({:addwork, n}, s), do: {:noreply, %{s | work: s.work + n}}

  def handle_info(:boom, state) do
    IO.puts("#{inspect(self())} has crashed. ##{inspect(state.work)} work is lost.")
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
end

children = Enum.map(workers, &Supervisor.child_spec({Employee, [name: &1]}, id: &1))

opts = [strategy: :one_for_all, name: supervisor]
Supervisor.start_link(children, opts)

# Verify that everything is running
Enum.all?([supervisor | workers], &(Process.whereis(&1) != nil))

Employee.add_work(A, 5000)
Employee.add_work(B, 20)
:timer.sleep(2000)
Employee.add_work(A, 5)
:timer.sleep(3000)
send(A, :boom)
