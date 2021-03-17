defmodule Student.Repo do
  use Ecto.Repo,
    otp_app: :student,
    adapter: Ecto.Adapters.Postgres
end
