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

# Configure Mix tasks and generators
config :a_webpack_demo,
  ecto_repos: [AWebpackDemo.Repo]

config :a_webpack_demo_web,
  ecto_repos: [AWebpackDemo.Repo],
  generators: [context_app: :a_webpack_demo]

# Configures the endpoint
config :a_webpack_demo_web, AWebpackDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hNJb/snhKOkxa4kfsNti0boZ0gWFA3NSPSnJcJNvNxSpGhkxuxFqoXPbAzxf6Vw5",
  render_errors: [view: AWebpackDemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AWebpackDemoWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "RccOwxmB"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
