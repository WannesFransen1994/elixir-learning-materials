defmodule UserDemo.Repo do
  use Ecto.Repo,
    otp_app: :user_demo,
    adapter: Ecto.Adapters.Postgres
end
