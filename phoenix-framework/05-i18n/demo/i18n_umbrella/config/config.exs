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

config :i18n_web,
  generators: [context_app: :i18n]

# Configures the endpoint
config :i18n_web, I18nWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TKy+q27mBVwAlTgSBf4yeYmO6mH9z8BGqVmkIMJUWZF8RIfoIbeQUbRdX2F7VrN7",
  render_errors: [view: I18nWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: I18n.PubSub,
  live_view: [signing_salt: "4BabNfdt"]

config :i18n_translations, I18nTranslations.Gettext,
  locales: ~w(en ja),
  default_locale: "en"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
