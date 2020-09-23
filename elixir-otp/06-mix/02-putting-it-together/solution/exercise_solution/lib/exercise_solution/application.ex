defmodule ExerciseSolution.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # This is first because the manager depends on the supervisor.
      #   The supervisor doesn't depend on the manager at all.
      {ExerciseSolution.InstanceSupervisor, []},
      {ExerciseSolution.GameServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExerciseSolution.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
