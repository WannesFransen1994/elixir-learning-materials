defmodule UserCats.CatContext.Cat do
  use Ecto.Schema
  import Ecto.Changeset

  alias UserCats.UserContext.User

  schema "cats" do
    field :name, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(cat, attrs) do
    cat
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc false
  def create_changeset(cat, attrs, user) do
    cat
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_assoc(:user, user)
  end
end
