import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :demo_associations, DemoAssociations.Repo,
  username: "root",
  password: "",
  hostname: "localhost",
  database: "demo_associations_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :demo_associations_web, DemoAssociationsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "n99GfBKGt36MCebtmvHGMFItscyZqc+RZVrsX/DgyhcXJyb5x7bGFC3kuJR4oIfQ",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :demo_associations, DemoAssociations.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
