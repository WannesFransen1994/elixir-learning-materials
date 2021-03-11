defmodule UserCats.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :date_of_birth, :date

      timestamps()
    end

  end
end
