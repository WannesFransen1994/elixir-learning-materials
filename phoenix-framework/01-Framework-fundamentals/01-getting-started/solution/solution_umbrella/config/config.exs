# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config



config :solution_web,
  generators: [context_app: :solution]

# Configures the endpoint
config :solution_web, SolutionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NIo29CwD6j0ggmKIcc03Vlt6lk4UAEC4TJGaUuu2O64c7spM2dGXQalXT3yJNO/K",
  render_errors: [view: SolutionWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Solution.PubSub,
  live_view: [signing_salt: "6Xk+WiJp"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
