defmodule ExtraMany2ManyUsageExample.Repo do
  use Ecto.Repo,
    otp_app: :extra_many_2_many_usage_example,
    adapter: Ecto.Adapters.MyXQL
end
