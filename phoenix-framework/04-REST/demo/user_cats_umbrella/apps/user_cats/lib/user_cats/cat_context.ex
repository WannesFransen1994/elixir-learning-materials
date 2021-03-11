defmodule UserCats.CatContext do
  import Ecto.Query, warn: false
  alias UserCats.Repo

  alias UserCats.CatContext.Cat
  alias UserCats.UserContext.User

  def load_cats(%User{} = u), do: u |> Repo.preload([:cats])

  def list_cats do
    Repo.all(Cat)
  end

  def get_cat!(id), do: Repo.get!(Cat, id)

  def create_cat(attrs, %User{} = user) do
    %Cat{}
    |> Cat.create_changeset(attrs, user)
    |> Repo.insert()
  end

  def update_cat(%Cat{} = cat, attrs) do
    cat
    |> Cat.changeset(attrs)
    |> Repo.update()
  end

  def delete_cat(%Cat{} = cat) do
    Repo.delete(cat)
  end

  def change_cat(%Cat{} = cat) do
    Cat.changeset(cat, %{})
  end
end
