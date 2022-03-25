# AuthN and AuthZ guide

## Intro

This guide is to demonstrate how we can rather quickly achieve a simple project with AuthN and AuthZ. This guide will cover 3 parts.

* Setting up our resources
* Configuring our AuthN
* Protecting routes with AuthZ

## Setup resources

First we'll create a user resource as we've done before. The User resource will store a role attribute which can be `User`, `Manager` or `Admin`. The CRUD operations to create/delete/delete users should of course be limited to the `Admin`role. First we'll create the resource:

```bash
 mix phx.gen.html UserContext User users username:string hashed_password:string role:string
```

After which we add the resources routes as well. Next we'll configure that our password should be hashed. Do that with one of the `comeonin` packages. For Argon this would be the following dependency:

```elixir
{:argon2_elixir, "~> 2.2"}
```

add this to your mix.exs of your model project in e.g. `apps/auth`.

_Note that windows can have some issues with compiling this module. Feel free to use pbkdf2._

### Schema

Next we'll adjust our schema like so:

```elixir
defmodule Auth.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  @acceptable_roles ["Admin", "Manager", "User"]

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string, default: "User"
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> validate_required([:username, :password, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
```

_Note that we've adjusted `:hashed_password` to `:password` in our `cast` and `validate_required` parameters._

There are several new things here. First of all the `virtual field`, this is to illustrate that we have a virtual field, a field which is not mapped by a column in our database. This could be used for extra input, custom computation / verification implementations. There are also options without this virtual field, but personally I like the explicicity of this field to illustrate its purposes.

After which we validate whether our provided role is "acceptable" with `validate_inclusion(changeset, field, has_to_be_in_this_enumerable)`. We also have a multi-clause function that pattern matches whether the provided data is valid or not. We do the hashing at the last step so that we don't waste CPU resources when the data is invalid. Likewise, if you'd add password complexity constraints, you'd put these before the last hashing step.

Know that normally you could provide better database integrity constraints if you'd make a roles table. Though for educational purposes we won't do this and write this in our User module as well.

### Acceptable roles

Though this is a small extra, our current form asks our role as a text field. Because we have a list of acceptable roles, lets adjust this quickly in our related files.

```elixir
# user_context.ex
defmodule Auth.UserContext do
  # ...

  defdelegate get_acceptable_roles(), to: User

  # ...
end
```

```elixir
# user_controller.ex
defmodule AuthWeb.UserController do
  # ...

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  # ...
end
```

```html
<!-- templates/user/form.html.eex -->
<%= form_for @changeset, @action, fn f -> %>
<%= if @changeset.action do %>
<div class="alert alert-danger">
  <p>Oops, something went wrong! Please check the errors below.</p>
</div>
<% end %>

<%= label f, :username %>
<%= text_input f, :username %>
<%= error_tag f, :username %>

<%= label f, :password %>
<%= text_input f, :password %>
<%= error_tag f, :password %>

<%= label f, :role %>
<%= select f, :role, @acceptable_roles %>
<%= error_tag f, :role %>

<div>
  <%= submit "Save" %>
</div>
<% end %>
```

We've also adjusted our auto-generated template to ask for the virtual password (and not the hashed password) in our form.

### Database integrity

In order to force our users to provide all the information at the database level, adjust your migration file.

```elixir
defmodule Auth.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :hashed_password, :string, null: false
      add :role, :string, null: false
    end
  end
end
```

### Seeding your database

This should normally be enough to set up your resource. While this is great, after we've added authentication we'll want some kind of default user accounts. Let us adjust the file in `apps/auth/priv/repo/seeds.exs`:

```elixir
{:ok, _cs} =
  Auth.UserContext.create_user(%{"password" => "t", "role" => "User", "username" => "user"})

{:ok, _cs} =
  Auth.UserContext.create_user(%{
    "password" => "t",
    "role" => "Manager",
    "username" => "manager"
  })

{:ok, _cs} =
  Auth.UserContext.create_user(%{"password" => "t", "role" => "Admin", "username" => "admin"})
```

Run `mix ecto.reset` and you should see some green debug output. Verify manually that the passwords are stored safely in your database as a hash.
