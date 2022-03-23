defmodule DemoAssociations.Repo.Migrations.AddUserHasTasks do
  use Ecto.Migration

  def change do
    create table(:user_has_tasks) do
      add :user_id, references(:users), null: false
      add :task_id, references(:tasks), null: false
    end
  end
end
