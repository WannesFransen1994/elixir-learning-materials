defmodule UserDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      UserDemo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: UserDemo.PubSub}
      # Start a worker by calling: UserDemo.Worker.start_link(arg)
      # {UserDemo.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: UserDemo.Supervisor)
  end
end
