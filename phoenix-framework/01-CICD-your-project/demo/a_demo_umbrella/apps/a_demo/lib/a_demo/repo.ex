defmodule ADemo.Repo do
  use Ecto.Repo,
    otp_app: :a_demo,
    adapter: Ecto.Adapters.MyXQL
end
