defmodule ExtraMany2ManyUsageExampleWeb.UserController do
  use ExtraMany2ManyUsageExampleWeb, :controller

  alias ExtraMany2ManyUsageExample.UserContext
  alias ExtraMany2ManyUsageExample.UserContext.User

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  # #######################################################
  #  CUSTOM
  # #######################################################

  def impersonate(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    users = UserContext.list_users()
    render(conn, "impersonate.html", users: users, user: user)
  end

  def befriend(conn, %{"origin_id" => origin_id, "target_id" => target_id}) do
    user1 = UserContext.get_user!(origin_id) |> ExtraMany2ManyUsageExample.Repo.preload(:friends)
    user2 = UserContext.get_user!(target_id) |> ExtraMany2ManyUsageExample.Repo.preload(:friends)

    case UserContext.befriend(user1, user2) do
      {:ok, _new_user} ->
        conn
        |> redirect(to: Routes.user_path(conn, :impersonate, user1))

      _ ->
        conn
        |> put_flash(:error, "something went wrong. Go ahead and debug")
        |> redirect(to: Routes.user_path(conn, :impersonate, user1))
    end
  end

  def follow(conn, %{"origin_id" => origin_id, "target_id" => target_id}) do
    user1 =
      UserContext.get_user!(origin_id)
      |> ExtraMany2ManyUsageExample.Repo.preload([:following, :followers])

    user2 =
      UserContext.get_user!(target_id)
      |> ExtraMany2ManyUsageExample.Repo.preload([:following, :followers])

    case UserContext.follow(user1, user2) do
      {:ok, _new_user} ->
        conn
        |> redirect(to: Routes.user_path(conn, :impersonate, user1))

      _var ->
        require IEx
        IEx.pry()

        conn
        |> put_flash(:error, "something went wrong. Go ahead and debug")
        |> redirect(to: Routes.user_path(conn, :impersonate, user1))
    end
  end
end
