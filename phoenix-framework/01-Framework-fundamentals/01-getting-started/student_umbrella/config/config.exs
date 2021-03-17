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
config :student,
  ecto_repos: [Student.Repo]

config :student_web,
  ecto_repos: [Student.Repo],
  generators: [context_app: :student]

# Configures the endpoint
config :student_web, StudentWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dULLdmxcED1vY86pKAQJlEMee4zFh2KDa1+mG2K+RnjY5rZDsWjP4U0r0ULtAnhB",
  render_errors: [view: StudentWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Student.PubSub,
  live_view: [signing_salt: "Eb7vSNDv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
