defmodule BuildingManager do
  use GenServer
  @me __MODULE__
  defstruct rooms: %{}

  #######
  # API #
  #######

  def start_link(args \\ []) do
    GenServer.start_link(@me, args, name: @me)
  end

  def list_rooms(server) do
    GenServer.call(server, {:room_info, :please})
  end

  # Use guards so that the API gives direct error messages to the calling process, not the server
  def add_room(server, room_name, n_people)
      when (is_atom(room_name) or is_binary(room_name)) and is_integer(n_people) and n_people > 0 do
    GenServer.cast(server, {:add_room, room_name, n_people})
  end

  def delete_room(server, room_name) when is_atom(room_name) or is_binary(room_name) do
    GenServer.cast(server, {:delete_room, room_name})
  end

  ############
  # Callback #
  ############

  def init(_args) do
    {:ok, %@me{}}
  end

  # Best to perform guards here as well, in case people try to use GenServer.cast directly.
  def handle_cast({:add_room, room_name, n_people}, %@me{} = state)
      when (is_atom(room_name) or is_binary(room_name)) and is_integer(n_people) and n_people > 0 do
    new_rooms = Map.put(state.rooms, room_name, n_people)
    {:noreply, %{state | rooms: new_rooms}}
  end

  def handle_cast({:delete_room, room_name}, %@me{} = state)
      when is_atom(room_name) or is_binary(room_name) do
    new_rooms = Map.delete(state.rooms, room_name)
    {:noreply, %{state | rooms: new_rooms}}
  end

  def handle_call({:room_info, :please}, _from, %@me{} = state) do
    {:reply, state.rooms, state}
  end
end
