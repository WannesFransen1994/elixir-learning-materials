use Mix.Config

# Configure your database
config :user_demo, UserDemo.Repo,
  username: "root",
  password: "",
  database: "user_demo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_demo_web, UserDemoWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
