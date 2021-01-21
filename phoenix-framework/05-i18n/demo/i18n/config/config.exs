# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :i18n, I18nWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KGgiDxAc/F0wUE0TySobfy/7pAYyj2jd5Ay0tqX6HtVhTycML/9bXrupqjWC7v1I",
  render_errors: [view: I18nWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: I18n.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :i18n, I18nWeb.Gettext,
  locales: ~w(en ja),
  default_locale: "en"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
