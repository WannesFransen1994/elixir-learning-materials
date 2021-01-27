defmodule I18n.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: I18n.PubSub}
      # Start a worker by calling: I18n.Worker.start_link(arg)
      # {I18n.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: I18n.Supervisor)
  end
end
