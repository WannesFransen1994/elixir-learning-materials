defmodule ExtraMany2ManyUsageExample.Repo.Migrations.AddUsersFollowUsers do
  use Ecto.Migration

  def change do
    create table(:users_follow_users) do
      add :follower_id, references(:users)
      add :following_id, references(:users)
    end

    # reminder of params: :table_name, [columns], opts = [e.g. name: :my_custom_name]
    create unique_index(:users_follow_users, [:follower_id, :following_id])

    # Do it also the other way around! The order of columns in indexes is critical for performance!
    # https://stackoverflow.com/questions/2292662/how-important-is-the-order-of-columns-in-indexes
    create unique_index(:users_follow_users, [:following_id, :follower_id])

    create table(:users_befriend_users) do
      add :friender_id, references(:users)
      add :befriended_id, references(:users)
    end

    # reminder of params: :table_name, [columns], opts = [e.g. name: :my_custom_name]
    create unique_index(:users_befriend_users, [:friender_id, :befriended_id])

    # Do it also the other way around! The order of columns in indexes is critical for performance!
    # https://stackoverflow.com/questions/2292662/how-important-is-the-order-of-columns-in-indexes
    create unique_index(:users_befriend_users, [:befriended_id, :friender_id])
  end
end
