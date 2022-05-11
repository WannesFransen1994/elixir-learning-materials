defmodule DemoAssociations.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DemoAssociations.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: DemoAssociations.PubSub}
      # Start a worker by calling: DemoAssociations.Worker.start_link(arg)
      # {DemoAssociations.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: DemoAssociations.Supervisor)
  end
end
