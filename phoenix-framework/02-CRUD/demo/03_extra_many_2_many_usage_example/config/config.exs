# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :extra_many_2_many_usage_example,
  ecto_repos: [ExtraMany2ManyUsageExample.Repo]

config :extra_many_2_many_usage_example_web,
  ecto_repos: [ExtraMany2ManyUsageExample.Repo],
  generators: [context_app: :extra_many_2_many_usage_example]

# Configures the endpoint
config :extra_many_2_many_usage_example_web, ExtraMany2ManyUsageExampleWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    view: ExtraMany2ManyUsageExampleWeb.ErrorView,
    accepts: ~w(html json),
    layout: false
  ],
  pubsub_server: ExtraMany2ManyUsageExample.PubSub,
  live_view: [signing_salt: "siGaQ8Sb"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/extra_many_2_many_usage_example_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
