defmodule I18nWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      I18nWeb.Telemetry,
      # Start the Endpoint (http/https)
      I18nWeb.Endpoint
      # Start a worker by calling: I18nWeb.Worker.start_link(arg)
      # {I18nWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: I18nWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    I18nWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
