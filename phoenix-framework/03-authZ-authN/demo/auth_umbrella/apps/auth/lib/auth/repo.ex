defmodule Auth.Repo do
  use Ecto.Repo,
    otp_app: :auth,
    adapter: Ecto.Adapters.MyXQL
end
