defmodule Gameserver do
  def retrieve_number_of_games_per_gameserver() do
    :global.registered_names()
    |> Enum.filter(fn {_nodename, modulename} ->
      modulename == GameManager
    end)
    |> Enum.map(fn gs ->
      n = gs |> :global.whereis_name() |> GameManager.get_amount_of_running_games()
      {gs, n}
    end)
  end
end
