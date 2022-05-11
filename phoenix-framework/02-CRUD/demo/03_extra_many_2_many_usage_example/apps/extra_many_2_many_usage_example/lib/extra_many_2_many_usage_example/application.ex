defmodule ExtraMany2ManyUsageExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ExtraMany2ManyUsageExample.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExtraMany2ManyUsageExample.PubSub}
      # Start a worker by calling: ExtraMany2ManyUsageExample.Worker.start_link(arg)
      # {ExtraMany2ManyUsageExample.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ExtraMany2ManyUsageExample.Supervisor)
  end
end
