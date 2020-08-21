# Configuring our cat context

We could create the complete schema and migration again, but as we've seen we can tremendously reduce this repetitive task with generators. Let us go and create our context and after that make the association links. Execute the following command:

```bash
$> mix phx.gen.context CatContext Cat cats name:string user_id:references:users
```

## Adjust the migration

As you can see we've got our migration, schema and context generated for us. Adjust your migration to not allow stray / nameless cats:

```elixir
defmodule UserCats.Repo.Migrations.CreateCats do
  use Ecto.Migration

  def change do
    create table(:cats) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create index(:cats, [:user_id])
  end
end
```

_If you want to go really fancy here, feel free to make your own version of this user-cat service. You can add images, age, etc..._

_From the docs: `:on_delete` - What to do if the referenced entry is deleted. May be `:nothing` (default), `:delete_all`, `:nilify_all`, or `:restrict`._

## Adjust the schema

We also need to adjust our cat and user schema:

```elixir
defmodule UserCats.CatContext.Cat do
  use Ecto.Schema
  import Ecto.Changeset

  alias UserCats.UserContext.User

  schema "cats" do
    field :name, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(cat, attrs) do
    cat
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
```

_Note: our changeset is not yet properly configured for the association. We'll do this later on._

Also adjust our user schema:

```elixir
defmodule UserCats.UserContext.User do
  # ...

  alias UserCats.CatContext.Cat

  schema "users" do
    field :date_of_birth, :date
    field :first_name, :string
    field :last_name, :string
    has_many :cats, Cat
  end

  # ...
end
```

Double check that your user CRUD operations are still working as expected. After that, let us go to the next section.
