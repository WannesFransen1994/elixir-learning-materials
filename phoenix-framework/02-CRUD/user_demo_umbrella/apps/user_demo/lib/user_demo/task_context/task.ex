defmodule UserDemo.TaskContext.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.UserContext.User

  schema "tasks" do
    field :deadline, :date
    field :title, :string
    # belongs_to :user, User
    many_to_many :users, User, join_through: "users_tasks"

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :deadline])
    |> validate_required([:title, :deadline])
  end
end
