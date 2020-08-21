defmodule Employee do
  use GenServer

  @work_interval 100

  @enforce_keys [ :name ]
  defstruct [ :name, work: 0 ]

  def start_link(name) do
    GenServer.start_link(__MODULE__, %__MODULE__{ name: name }, name: name)
  end

  def init(args) do
    Process.send_after(self(), :work, @work_interval)
    {:ok, args}
  end

  def handle_cast({:add_work, n}, state = %__MODULE__{work: work}) do
    {:noreply, %{state | work: n + work}}
  end

  def handle_cast(:boom, state = %__MODULE__{name: name}) do
    IO.puts("#{inspect name} died")
    {:stop, :shutdown, state}
  end

  def handle_info(:work, state = %__MODULE__{name: name, work: work}) do
    Process.send_after(self(), :work, @work_interval)
    IO.puts("#{inspect name} has #{work} left")

    {:noreply, %{ state | work: max(0, work - 1)}}
  end

  def add_work(id, n) do
    GenServer.cast(id, {:add_work, n})
  end

  def boom(id) do
    GenServer.cast(id, :boom)
  end
end


children = [A, B, C] |> Enum.map( fn id -> %{ id: id, start: { Employee, :start_link, [id] } } end )

Supervisor.start_link(children, strategy: :one_for_one)

Employee.add_work(A, 100)
Employee.add_work(B, 100)
Employee.add_work(C, 100)

:timer.sleep(500)

Employee.boom(A)

:timer.sleep(1000)
