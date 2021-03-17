defmodule UserDemo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :deadline, :date
      add :user_id, references(:users)

      timestamps()
    end

  end
end
