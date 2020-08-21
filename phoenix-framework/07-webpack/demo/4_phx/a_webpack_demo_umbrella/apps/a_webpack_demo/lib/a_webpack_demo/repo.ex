defmodule AWebpackDemo.Repo do
  use Ecto.Repo,
    otp_app: :a_webpack_demo,
    adapter: Ecto.Adapters.MyXQL
end
