defmodule UserDemo.Repo.Migrations.CreateUsersTasks do
  use Ecto.Migration

  def change do
    create table(:users_tasks) do
      add :user_id, references(:users)
      add :task_id, references(:tasks)
    end

    create unique_index(:users_tasks, [:user_id, :task_id])
  end
end
