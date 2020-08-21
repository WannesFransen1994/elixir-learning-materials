defmodule GameManager do
  use GenServer
  alias Gameserver.DynamicGameSupervisor

  defstruct games: %{}

  ##########
  #  API   #
  ##########
  def start_link(_ \\ %{}),
    do: GenServer.start_link(__MODULE__, :ok, name: {:via, :global, {Node.self(), __MODULE__}})

  def get_amount_of_running_games(pid), do: GenServer.call(pid, :get_amount_running_games)

  def start_game() do
    data = retrieve_number_of_games_per_gameserver()

    data
    |> Enum.min_by(fn {_gs, n} -> n end)
    |> elem(0)
    |> :global.whereis_name()
    |> GenServer.cast({:start_game, data})
  end

  ##########
  # SERVER #
  ##########
  def init(_), do: {:ok, %__MODULE__{}}

  def handle_call(:get_amount_running_games, _, s),
    do: {:reply, s.games |> Map.keys() |> length, s}

  def handle_cast({:start_game, data}, s) do
    newn = data |> Enum.map(fn {_, n} -> n end) |> Enum.sum()
    key = :"game#{newn}"

    {:ok, p1} = DynamicSupervisor.start_child(DynamicGameSupervisor, {PingPong, []})
    {:ok, p2} = DynamicSupervisor.start_child(DynamicGameSupervisor, {PingPong, []})

    send(p2, {:ping, p1})
    {:noreply, %{s | games: Map.put(s.games, key, ping: p1, pong: p2)}}
  end

  defp retrieve_number_of_games_per_gameserver() do
    :global.registered_names()
    |> Enum.filter(fn {_nodename, modulename} ->
      modulename == __MODULE__
    end)
    |> Enum.map(fn gs ->
      n = gs |> :global.whereis_name() |> GameManager.get_amount_of_running_games()
      {gs, n}
    end)
  end
end
