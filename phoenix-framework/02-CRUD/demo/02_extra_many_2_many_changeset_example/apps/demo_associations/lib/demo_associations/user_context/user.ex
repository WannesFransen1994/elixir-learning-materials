defmodule DemoAssociations.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias DemoAssociations.TaskContext.Task

  schema "users" do
    field :name, :string

    many_to_many :tasks, Task, join_through: "user_has_tasks"
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
