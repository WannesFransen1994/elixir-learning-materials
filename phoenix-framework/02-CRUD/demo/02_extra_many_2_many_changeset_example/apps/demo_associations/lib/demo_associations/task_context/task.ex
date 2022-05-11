defmodule DemoAssociations.TaskContext.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias DemoAssociations.UserContext.User
  alias DemoAssociations.TaskContext.Task

  schema "tasks" do
    field :title, :string

    many_to_many :users, User, join_through: "user_has_tasks"
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

  @doc false
  def assign_user_to_task_changeset(%Task{} = task, %User{} = user) do
    new_users = [user | task.users]

    task
    |> cast(%{}, [])
    |> put_assoc(:users, new_users)
  end
end
