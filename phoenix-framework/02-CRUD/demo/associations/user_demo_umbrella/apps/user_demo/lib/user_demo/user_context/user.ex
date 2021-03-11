defmodule UserDemo.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.TaskContext.Task
  alias UserDemo.UserContext.Credential

  schema "users" do
    field :age, :integer
    field :name, :string
    # has_many :tasks, Task # I'm commented
    many_to_many :tasks, Task, join_through: "users_tasks" # I'm new!
    has_one :credential, Credential
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
