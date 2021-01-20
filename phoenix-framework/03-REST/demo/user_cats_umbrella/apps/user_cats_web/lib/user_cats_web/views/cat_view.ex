defmodule UserCatsWeb.CatView do
  use UserCatsWeb, :view
  alias UserCatsWeb.CatView

  def render("index.json", %{cats: cats}) do
    %{data: render_many(cats, CatView, "cat.json")}
  end

  def render("show.json", %{cat: cat}) do
    %{data: render_one(cat, CatView, "cat.json")}
  end

  def render("cat.json", %{cat: cat}) do
    %{id: cat.id, name: cat.name}
  end
end
