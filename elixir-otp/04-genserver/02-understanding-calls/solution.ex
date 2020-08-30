defmodule BuildingManager do
  use GenServer

  #######
  # API #
  #######

  def start_link(args) do
    # Note: for now we will not worry about the state.
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def list_rooms() do
    # Note: it is not required that the 2nd argument is a tuple.
    GenServer.call(__MODULE__, {:room_info, :please})
  end

  ############
  # Callback #
  ############

  def init(args) do
    IO.puts("\n\nWe received the following args and are completely ignoring these:")
    IO.inspect(args, label: __MODULE__.INIT)

    initial_state = %{rooms: []}
    {:ok, initial_state}
  end

  def handle_call({:room_info, :please}, from, state) do
    IO.puts("Hello, I am #{inspect(self())} and I've gotten a call from #{inspect(from)}")
    {:reply, state.rooms, state}
  end
end
