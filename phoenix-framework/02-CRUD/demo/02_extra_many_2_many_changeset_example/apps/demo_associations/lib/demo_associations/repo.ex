defmodule DemoAssociations.Repo do
  use Ecto.Repo,
    otp_app: :demo_associations,
    adapter: Ecto.Adapters.MyXQL
end
