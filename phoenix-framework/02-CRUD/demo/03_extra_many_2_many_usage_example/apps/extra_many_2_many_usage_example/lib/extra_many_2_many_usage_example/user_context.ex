defmodule ExtraMany2ManyUsageExample.UserContext do
  import Ecto.Query, warn: false
  alias ExtraMany2ManyUsageExample.Repo

  alias ExtraMany2ManyUsageExample.UserContext.User

  def list_friends(id) do
    query =
      from ubfu in "users_befriend_users",
        join: u1 in User,
        join: u2 in User,
        on: u1.id == ubfu.friender_id and u2.id == ubfu.befriended_id,
        where: ubfu.friender_id == ^id or ubfu.befriended_id == ^id,
        select: {u1, u2}

    Repo.all(query)
  end

  def list_users, do: Repo.all(User)

  # ExtraMany2ManyUsageExample.UserContext.list_users_preloaded()
  def list_users_preloaded do
    list_users()
    |> Enum.map(fn u ->
      Repo.preload(u, [:friends, :followers, :following])
    end)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def befriend(%User{} = origin_user, %User{} = target_user) do
    origin_user
    |> User.befriend_someone_changeset(target_user)
    |> Repo.update()
  end

  def follow(%User{} = origin_user, %User{} = target_user) do
    origin_user
    |> User.follow_someone_changeset(target_user)
    |> Repo.update()
  end
end
