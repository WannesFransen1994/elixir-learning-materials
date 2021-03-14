defmodule UserDemo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :date_of_birth, :date, null: false
    end

    create unique_index(:users, [:first_name, :last_name, :date_of_birth],
             name: :unique_users_index)
  end
end
