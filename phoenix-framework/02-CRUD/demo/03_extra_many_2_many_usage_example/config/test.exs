import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :extra_many_2_many_usage_example, ExtraMany2ManyUsageExample.Repo,
  username: "root",
  password: "",
  hostname: "localhost",
  database: "extra_many_2_many_usage_example_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :extra_many_2_many_usage_example_web, ExtraMany2ManyUsageExampleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "MwRKLrNmWQpRNLHCNCVRjb+a9yYRLaUcQLxLrNOxx3Y+xUEpAZOdivO+66urvuIL",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
