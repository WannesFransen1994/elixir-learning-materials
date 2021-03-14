defmodule Student.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Student.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Student.PubSub}
      # Start a worker by calling: Student.Worker.start_link(arg)
      # {Student.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Student.Supervisor)
  end
end
