use Mix.Config

# Configure your database
config :a_demo, ADemo.Repo,
  username: System.get_env("DB_USER") || "root",
  password: System.get_env("DB_PASSWORD") || "t",
  database: System.get_env("DB_NAME") || "a_demo_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.get_env("DB_POOL_SIZE", "1") |> Integer.parse() |> elem(0)

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :a_demo_web, ADemoWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
