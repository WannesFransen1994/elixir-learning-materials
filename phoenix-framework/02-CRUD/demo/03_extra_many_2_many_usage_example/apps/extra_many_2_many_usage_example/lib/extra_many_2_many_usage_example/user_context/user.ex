defmodule ExtraMany2ManyUsageExample.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  @me __MODULE__

  schema "users" do
    field :name, :string

    many_to_many :following, @me,
      join_through: "users_follow_users",
      join_keys: [follower_id: :id, following_id: :id]

    many_to_many :followers, @me,
      join_through: "users_follow_users",
      join_keys: [following_id: :id, follower_id: :id]

    many_to_many :friends, @me,
      join_through: "users_befriend_users",
      join_keys: [friender_id: :id, befriended_id: :id]

    field :vowels, :integer, virtual: true
  end

  # alias ExtraMany2ManyUsageExample.UserContext.User; %User{} |> User.changeset(%{name: "wannes"})
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  # Simple field population
  @doc false
  def changeset_v1(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> populate_vowels()
    |> validate_required([:name])
    |> validate_length(:vowels, min: 2)
  end

  defp populate_vowels(%Ecto.Changeset{changes: %{name: name}} = changeset) do
    n_vowels =
      String.codepoints(name)
      |> Enum.count(fn letter ->
        letter in ["a", "i", "u", "e", "o"]
      end)

    changeset
    |> put_change(:vowels, n_vowels)
  end

  @doc false
  def changeset_v2(user, attrs) do
    cs =
      user
      |> cast(attrs, [:name])

    cs
    |> validate_required([:name])
    |> validate_change(:name, &my_custom_validator(&1, &2, cs))
  end

  # Note! If the above validate required is false, it WILL NOT activate this function!
  #   Extra note: for demonstration purposes I've given the full changeset as an extra
  #     param. In this case it isn't necessary, but it's useful if you want do pass
  #     extra data that's necessary for validations.
  defp my_custom_validator(:name, _name_data, %Ecto.Changeset{changes: %{name: name}}) do
    consonants =
      String.codepoints(name)
      |> Enum.count(fn letter -> letter not in ["a", "i", "u", "e", "o"] end)

    case consonants > 2 do
      true -> []
      false -> [name: "You need more than 2 consonants!"]
    end
  end

  # defp my_custom_validator(:name, _name_data, changeset) do
  #   require IEx
  #   IEx.pry()
  # end

  @doc false
  def befriend_someone_changeset(%@me{} = user, %@me{} = user_that_you_want_to_befriend) do
    # Prepend!
    # Note: assuming that you've preloaded the necessary data. Prefer Explicit over implicit double queries
    users = [user_that_you_want_to_befriend | user.friends]

    user
    # Convert to Changeset here
    |> cast(%{}, [])
    |> put_assoc(:friends, users)
  end

  @doc false
  def follow_someone_changeset(%@me{} = user, %@me{} = user_that_you_want_to_follow) do
    users = [user_that_you_want_to_follow | user.following]

    user
    |> cast(%{}, [])
    |> put_assoc(:following, users)
  end
end
