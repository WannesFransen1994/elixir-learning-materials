defmodule UserDemoWeb.UserController do
  use UserDemoWeb, :controller

  alias UserDemo.Repo
  alias UserDemo.UserContext
  alias UserDemo.UserContext.User

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
    new_user = UserContext.load_user(user, [:credential])
    render(conn, "show.html", user: new_user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    new_user = UserContext.load_user(user, [:credential])
    changeset = UserContext.change_user(new_user)
    render(conn, "edit.html", user: new_user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)
    new_user = UserContext.load_user(user, [:credential])

    case UserContext.update_user(new_user, user_params) do
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
    new_user = UserContext.load_user(user, [:credential])
    {:ok, _user} = UserContext.delete_user(new_user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
