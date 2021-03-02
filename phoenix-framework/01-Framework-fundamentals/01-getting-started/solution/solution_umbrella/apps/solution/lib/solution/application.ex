defmodule Solution.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Solution.PubSub}
      # Start a worker by calling: Solution.Worker.start_link(arg)
      # {Solution.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Solution.Supervisor)
  end
end
