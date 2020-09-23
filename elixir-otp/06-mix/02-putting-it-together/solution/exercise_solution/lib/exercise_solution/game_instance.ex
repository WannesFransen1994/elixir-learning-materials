defmodule ExerciseSolution.GameInstance do
  use GenServer

  @me __MODULE__

  @enforce_keys [:report_timer]
  defstruct players: %{}, report_timer: nil

  def start_link(args) do
    case Keyword.pop(args, :name) do
      {nil, _args} -> {:error, :no_name_param}
      {value, remaining_args} -> GenServer.start_link(@me, remaining_args, name: value)
    end
  end

  def assign_player(instance, player_name, player_pid) do
    GenServer.call(instance, {:add_player, player_name, player_pid})
  end

  def init(_args) do
    timer = :timer.send_interval(10_000, :report_to_gameserver)
    {:ok, struct!(@me, report_timer: timer)}
  end

  def handle_call({:add_player, p_name, p_pid}, _from, %@me{players: ps} = s) do
    case Map.get(ps, p_name) do
      nil ->
        new_ps = Map.put(ps, p_name, p_pid)
        {:reply, {:connected_to_instance, self()}, %{s | players: new_ps}}

      pid ->
        {:reply, {:error, :already_connected_client, pid, :to_instance, self()}, s}
    end
  end

  def handle_info(:report_to_gameserver, state) do
    n_players = state.players |> Map.keys() |> length()

    send(ExerciseSolution.GameServer, {:report_player_load, self(), n_players})
    {:noreply, state}
  end
end
