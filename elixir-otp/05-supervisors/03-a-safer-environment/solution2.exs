defmodule Employee do
  use GenServer

  @initial_work 50
  @work_interval 50

  @enforce_keys [ :name ]
  defstruct [ :name, colleagues: [], work: @initial_work ]

  def start_link({name, colleagues}) do
    GenServer.start_link(__MODULE__, %__MODULE__{ name: name, colleagues: colleagues }, name: name)
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

  def terminate(reason, state = %__MODULE__{colleagues: colleagues, work: work}) do
    IO.puts("Terminating #{reason} with state #{inspect state}")

    n_colleages = length(colleagues)
    work_per_colleague = div(work, n_colleages)

    Enum.each(colleagues, fn colleague ->
      IO.puts("Giving #{work_per_colleague} of work to #{inspect colleague}")
      Employee.add_work(colleague, work_per_colleague)
    end)
  end
end

employees = [A, B, C]

children = Enum.map( employees, fn id ->
  colleagues = Enum.reject(employees, &(&1 == id))
  %{ id: id, start: { Employee, :start_link, [{id, colleagues}] } }
end )

Supervisor.start_link(children, strategy: :one_for_one)

:timer.sleep(500)

IO.puts "Boom!!"
Employee.boom(A)

:timer.sleep(500)
