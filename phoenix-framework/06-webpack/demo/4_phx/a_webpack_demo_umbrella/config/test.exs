use Mix.Config

# Configure your database
config :a_webpack_demo, AWebpackDemo.Repo,
  username: "root",
  password: "",
  database: "a_webpack_demo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :a_webpack_demo_web, AWebpackDemoWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
