defmodule UserDemo.UserContext.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.UserContext.User

  schema "credentials" do
    field :password, :string
    field :username, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end
end
