# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExtraMany2ManyUsageExample.Repo.insert!(%ExtraMany2ManyUsageExample.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ExtraMany2ManyUsageExample.UserContext.User
alias ExtraMany2ManyUsageExample.UserContext

{:ok, _} = UserContext.create_user(%{name: "user 1"})
{:ok, _} = UserContext.create_user(%{name: "user 2"})
{:ok, _} = UserContext.create_user(%{name: "user 3"})
