use Mix.Config

# Configure your database
config :user_cats, UserCats.Repo,
  username: "wannes",
  password: "t",
  database: "user_cats_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_cats_web, UserCatsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
