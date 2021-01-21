# Create operation

You've already seen how to create a [schema](https://hexdocs.pm/ecto/Ecto.Schema.html) and [migration](https://hexdocs.pm/ecto_sql/Ecto.Migration.html). You should follow the links to understand what they are used for. Here we'll focus on the create operation from CRUD. Create an umbrella application where the web project is apart from the actual logic / model project.

```bash
mix phx.new user_demo --umbrella --database mysql
```

## Migration and schema

First we'll make a schema and migration. Let's make an example of a stereotypical user table with columns first_name, last_name and date_of_birth using a generator.

```bash
mix phx.gen.schema User users first_name:string last_name:string date_of_birth:date
```

Our users needs to be unique, so let us also make an unique index on the date of birth, first and last name to ensure data integrity. We don't need the auto-generated timestamps so delete those. Your migration file should now look similar to this:

```elixir
defmodule UserDemo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :date_of_birth, :date, null: false
    end

    create unique_index(:users, [:first_name, :last_name, :date_of_birth],
             name: :unique_users_index
           )
  end
end
```
A schema is a representation of a data structure and what associated fields match with the database.

When an unique index conflic occurs, this would raise an error our system doesn't know about. That's why we have to specify this unique constraint in our schema as well.
```elixir
defmodule UserDemo.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :date_of_birth, :date
    field :first_name, :string
    field :last_name, :string
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :date_of_birth])
    |> validate_required([:first_name, :last_name, :date_of_birth])
    |> unique_constraint(:date_of_birth,
      name: :unique_users_index,
      message:
        "Wow that's coincidence! " <>
          "Another person with the same first name and last name was born at this day. " <>
          "Oh gosh, our system can't deal with this. " <>
          "Contact our administrators or change your name. "
    )
  end
end
```
 A [changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) is used to track changes on a user struct. An example could be the following:

```bash
# in apps/user_demo/
mix ecto.reset
# This is an alias for mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run priv/repo/seeds.exs
# It is used to drop your existing database, create a new empty database, run your migratations to create the database tables and fill those tables with structures present in your seeds file.

# in / , your project root folder:
iex -S mix phx.server
#This starts the phoenix server in an interactive mode
Erlang/OTP 22 [erts-10.6.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

[info] Running UserDemoWeb.Endpoint with cowboy 2.7.0 at 0.0.0.0:4000 (http)
[info] Access UserDemoWeb.Endpoint at http://localhost:4000
Interactive Elixir (1.10.0) - press Ctrl+C to exit (type h() ENTER for help)
# Create an User struct based on the earlier created user schema
iex(1)> initial_user = %UserDemo.UserContext.User{}
%UserDemo.UserContext.User{
  __meta__: #Ecto.Schema.Metadata<:built, "users">,
  date_of_birth: nil,
  first_name: nil,
  id: nil,
  last_name: nil
}
iex(2)>
nil
# A manually defined dictionary of parameters. Normally this will be defined by an external sources such as a webform.
iex(3)> parameters_provided_by_external_sources = %{"date_of_birth" => Date.utc_today, "first_name" => "John", "last_name" => "Doe"}
%{
  "date_of_birth" => ~D[2020-02-06],
  "first_name" => "John",
  "last_name" => "Doe"
}
iex(4)>
nil
# Run the changeset function defined in the user schema on the created user with the provided parameters to create an Ecto.Changeset that represents the database changes, together with any error.
iex(5)> UserDemo.UserContext.User.changeset initial_user, parameters_provided_by_external_sources
#Ecto.Changeset<
  action: nil,
  changes: %{
    date_of_birth: ~D[2020-02-06],
    first_name: "John",
    last_name: "Doe"
  },
  errors: [],
  data: #UserDemo.UserContext.User<>,
  valid?: true
>
iex(6)>
```

_The actually used commands above are, feel free to copy paste them to verify the output ourself:_

```elixir
initial_user = %UserDemo.UserContext.User{}

parameters_provided_by_external_sources = %{"date_of_birth" => Date.utc_today, "first_name" => "John", "last_name" => "Doe"}

UserDemo.UserContext.User.changeset initial_user, parameters_provided_by_external_sources
```

## Making a context

Because we'll have to do a lot of user-related operations, we'll make a context for this. This way our controllers can interact with the context to perform domain logic rather then interacting directly with the schema.  (No domain logic in the controllers!)

Make a new file (and folder) `user_demo/lib/user_demo/user_context/user_context.ex` and add the following code:

```elixir
defmodule UserDemo.UserContext do
  alias __MODULE__.User
  alias UserDemo.Repo

  @doc "Returns a user changeset"
  def change_user(%User{} = user) do
    user |> User.changeset(%{})
  end

  @doc "Creates a user based on some external attributes"
  def create_user(attributes) do
    %User{}
    |> User.changeset(attributes)
    |> Repo.insert()
  end
end
```

## Configuring our controller

We've already seen how we can configure our router. We'll need to add 2 routes in order to allow our users to create a user account:

```elixir
    get "/users/new", UserController, :new
    post "/users", UserController, :create
```

Our controller doesn't exist yet, let us make one with the necessary actions. 

As just configured in the router the UserController will need 2 matching actions. The `new/2` action will be called whenever a HTTP GET request is made to `/users/new` and the `create/2` action whenever a HTTP POST request is made to `/users`.

_Reminder: An action is a regular function that receives the connection and the request parameters as arguments._

```elixir
defmodule UserDemoWeb.UserController do
  use UserDemoWeb, :controller

  alias UserDemo.UserContext
  alias UserDemo.UserContext.User

  def new(conn, _parameters) do
    changeset = UserContext.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User #{user.first_name} #{user.last_name} created successfully.")
        |> redirect(to: Routes.user_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
```

For now let us forget that we're still missing our view and templates. We can see the `new/2` and `create/2` actions. For the `new/2` action, we create a changeset as forms need these to render themselves. Because it is new, we'll create a new struct and pass it as a parameter. Then when we render the template, we pass the changeset so that we can use it later on.

The `create/2` action on the other hand, will receive some parameters from the post requests. These are already parsed thanks to the plugs in the `:browser` pipeline. We use these attributes to create a new user, and if no errors are present we'll  pattern matched and redirect to a new form (for now). Otherwise you'll render that same form again with the necessary errors. As visibile in the pattern match, the second value returned with the `:error` is the Ecto.Changeset. This Ecto.Changeset was matched against the database but had validation errors. (e.g. earlier defined `unique_users_index`-constraint). Those validations errors are shown in the form to notify the user of any mistakes.

## The view

Creating the view is rather simple, we'll just need the following code:

```elixir
defmodule UserDemoWeb.UserView do
  use UserDemoWeb, :view
end
```

## Making a template

Then we'll create the templates. First we'll create the folder `templates/user/` as phoenix will automatically navigate to this folder. After which we'll need a `new.html.eex` template. Let us create a simple form:

```html
<h1>New User</h1>

<%= form_for @changeset, Routes.user_path(@conn, :create), fn f -> %>
<%= if @changeset.action do %>
<div class="alert alert-danger">
  <p>Oops, something went wrong! Please check the errors below.</p>
</div>
<% end %>

<%= label f, :first_name %>
<%= text_input f, :first_name %>
<%= error_tag f, :first_name %>

<%= label f, :last_name %>
<%= text_input f, :last_name %>
<%= error_tag f, :last_name %>

<%= label f, :date_of_birth %>
<%= date_select f, :date_of_birth, year: [options: 1910..2021] %>
<%= error_tag f, :date_of_birth %>

<div>
  <%= submit "Save" %>
</div>
<% end %>
```

So what exactly is happening here? First we create a form with the `form_for` macro. We pass the changeset (formdata) to it and it'll automatically match the values to the fields. After that we give a path to where the post request needs to be sent using path helpers. Finally we use the anonymous function f to build our form.
<!-- markdown-link-check-disable -->
Now everything is in place and we can run the application server. Do this by executing the following command in the terminal and visit [localhost:4000/users/new](http://localhost:4000/users/new) in your prefered browser. 
<!-- markdown-link-check-enable -->
```bash
iex -S mix phx.server
```
When you try it out, you can make a new user and it'll show nice flash messages. These messages are also parsed thanks to plugs in the browser pipeline (check your `router.ex` file).