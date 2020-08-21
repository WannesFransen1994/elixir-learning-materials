defmodule UserCats.Repo do
  use Ecto.Repo,
    otp_app: :user_cats,
    adapter: Ecto.Adapters.MyXQL
end
