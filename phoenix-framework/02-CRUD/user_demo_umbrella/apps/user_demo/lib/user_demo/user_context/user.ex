defmodule UserDemo.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.TaskContext.Task
  alias UserDemo.UserContext.Credential

  schema "users" do
    field :age, :integer
    field :name, :string
    # has_many :tasks, Task
    many_to_many :tasks, Task, join_through: "users_tasks"
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs, %Credential{} = credential) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
    |> put_assoc(:credential, credential)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
    |> cast_assoc(:credential)
  end
end
