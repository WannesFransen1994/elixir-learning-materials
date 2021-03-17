defmodule StudentWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      StudentWeb.Telemetry,
      # Start the Endpoint (http/https)
      StudentWeb.Endpoint
      # Start a worker by calling: StudentWeb.Worker.start_link(arg)
      # {StudentWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StudentWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    StudentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
