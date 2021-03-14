defmodule UserCatsWeb.CatController do
  use UserCatsWeb, :controller

  alias UserCats.UserContext
  alias UserCats.CatContext
  alias UserCats.CatContext.Cat

  action_fallback UserCatsWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    user = UserContext.get_user!(user_id)
    user_with_loaded_cats = CatContext.load_cats(user)
    render(conn, "index.json", cats: user_with_loaded_cats.cats)
  end

  def create(conn, %{"user_id" => user_id, "cat" => cat_params}) do
    user = UserContext.get_user!(user_id)

    case CatContext.create_cat(cat_params, user) do
      {:ok, %Cat{} = cat} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_cat_path(conn, :show, user_id, cat))
        |> render("show.json", cat: cat)

      {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
    end
  end

  def show(conn, %{"id" => id}) do
    cat = CatContext.get_cat!(id)
    render(conn, "show.json", cat: cat)
  end

  def update(conn, %{"id" => id, "cat" => cat_params}) do
    cat = CatContext.get_cat!(id)

    case CatContext.update_cat(cat, cat_params) do
      {:ok, %Cat{} = cat} ->
        render(conn, "show.json", cat: cat)

      {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
    end
  end

  def delete(conn, %{"id" => id}) do
    cat = CatContext.get_cat!(id)

    with {:ok, %Cat{}} <- CatContext.delete_cat(cat) do
      send_resp(conn, :no_content, "")
    end
  end
end
