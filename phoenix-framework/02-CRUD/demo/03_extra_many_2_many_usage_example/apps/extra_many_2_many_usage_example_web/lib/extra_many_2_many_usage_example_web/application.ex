defmodule ExtraMany2ManyUsageExampleWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExtraMany2ManyUsageExampleWeb.Telemetry,
      # Start the Endpoint (http/https)
      ExtraMany2ManyUsageExampleWeb.Endpoint
      # Start a worker by calling: ExtraMany2ManyUsageExampleWeb.Worker.start_link(arg)
      # {ExtraMany2ManyUsageExampleWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExtraMany2ManyUsageExampleWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExtraMany2ManyUsageExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
