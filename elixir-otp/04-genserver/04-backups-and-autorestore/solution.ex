defmodule BuildingManager do
  use GenServer
  @me __MODULE__
  @backup_filename "ROOMS.csv"
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
    :timer.send_interval(1000 * 10, :backup)
    {:ok, %@me{}, {:continue, :restore}}
  end

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

  def handle_info(:backup, %@me{} = state) do
    File.write!(@backup_filename, generate_csv_lines(state.rooms))
    {:noreply, state}
  end

  def handle_call({:room_info, :please}, _from, %@me{} = state) do
    {:reply, state.rooms, state}
  end

  def handle_continue(:restore, state) do
    rooms =
      case File.exists?(@backup_filename) do
        true -> parse_rooms(@backup_filename)
        false -> %{}
      end

    {:noreply, %{state | rooms: rooms}}
  end

  ############################
  # PRIVATE HELPER FUNCTIONS #
  ############################

  defp generate_csv_lines(rooms), do: Enum.map(rooms, &generate_csv_line/1) |> Enum.join("\n")

  defp generate_csv_line({k, v}) when is_atom(k), do: "#{k},atom,#{v}"
  defp generate_csv_line({k, v}) when is_binary(k), do: "#{k},string,#{v}"

  defp parse_room([key, "string", value]), do: {key, parse_room_number(value)}
  defp parse_room([key, "atom", value]), do: {String.to_atom(key), parse_room_number(value)}

  defp parse_rooms(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(&String.trim_trailing(&1, ","))
    |> Enum.map(&String.trim_trailing(&1, "\r"))
    |> Enum.map(&String.trim_trailing(&1, " "))
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&parse_room/1)
    |> Enum.into(%{})
  end

  defp parse_room_number(string) do
    {number, ""} = Integer.parse(string)
    number
  end
end
