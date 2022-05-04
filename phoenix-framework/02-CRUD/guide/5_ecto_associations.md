# Associations

An association defines a relationship between two entity objects based on common attributes.

In order to create associations we first have to define another schema and migration. We will create those using generators this time. 

```bash
mix phx.gen.schema TaskContext.Task tasks title:string deadline:date
mix phx.gen.schema UserContext.Credential credentials username:string password:string
```
_Note that saving passwords in plain text is never a good idea! Always save hashed passwords as we will see in a later guide_

## Belongs To/Has Many 
It is obvious to see that there exists a one-to-many relation between a user and a task. A user can have multiple tasks assigned while a task can only be assigned to a single user. In order to create the association between user and task we have to change the migration first. As a task will keep user_id as a foreign key, only the task migration has to be changed.

```Elixir
defmodule UserDemo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :deadline, :date
      add :user_id, references(:users) #I'm new!

      timestamps()
    end

  end
end
```
Next up we will change the schema's. Here we have to edit both the user and the task schema because from a user perspective we want to be able to retrieve all tasks while from a task perspective we want to be able to retrieve the assigned user.

```Elixir
defmodule UserDemo.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.TaskContext.Task

  schema "users" do
    field :age, :integer
    field :name, :string
    has_many :tasks, Task #I'm new!
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
```

```Elixir
defmodule UserDemo.TaskContext.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.UserContext.User

  schema "tasks" do
    field :deadline, :date
    field :title, :string
    belongs_to :user, User #I'm new!
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :deadline])
    |> validate_required([:title, :deadline])
  end
end
```
That's all, now run our migrations again for the changes to take effect.

## Belongs To/Has One
Next up is a one-to-one relation between a user and the user credentials. A user has only one set of credentials to authenticate himself. Signing in with credentials will also uniquely identify the user. 

Just like the one-to-many relationship we have to change the credentials migration to let the database know about the association. We will also create a unique index to make sure only one entry can be included.
```Elixir
    defmodule UserDemo.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :username, :string
      add :password, :string
      add :user_id, references(:users) #I'm new!
      timestamps()
    end

    create unique_index(:credentials, [:user_id])

  end
end

```

Besides editing the migrations some additional changes have to be made to the schema's of both the user and the credentials.
```Elixir
defmodule UserDemo.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.TaskContext.Task
  alias UserDemo.UserContext.Credential

  schema "users" do
    field :age, :integer
    field :name, :string
    has_many :tasks, Task
    has_one :credential, Credential #I'm new!
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
```

```Elixir
defmodule UserDemo.UserContext.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.UserContext.User

  schema "credentials" do
    field :password, :string
    field :username, :string
    belongs_to :user, User #I'm new!
    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end
end

```

One-to-one and One-to-many relations are very similar and easy to implement. Run the migrations again so that the changes apply.

## Many To Many
Many-to-many relationships are considered difficult associations. Mostly because you need *a relationship table* in order the preserve the relationship. We will change our one-to-many example into a many-to-many relationship meaning that a user can still have multiple tasks, but a task can be assigned to multiple users.

start by creating the *relationship table* as a migration, we will use a generator.
```bash
mix ecto.gen.migration create_users_tasks
```

In the newly create migration file add the associations like before. We will also create a unique index to make sure only one entry can be included per user-task combination.
```Elixir
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
```
Next up we change the schema's once again.

```Elixir
defmodule UserDemo.TaskContext.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.UserContext.User

  schema "tasks" do
    field :deadline, :date
    field :title, :string
    # belongs_to :user, User #I'm commented
    many_to_many :users, User, join_through: "users_tasks" # I'm new!
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :deadline])
    |> validate_required([:title, :deadline])
  end
end
```

```Elixir
defmodule UserDemo.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias UserDemo.TaskContext.Task
  alias UerDemo.CredentialContext.Credential

  schema "users" do
    field :age, :integer
    field :name, :string
    # has_many :tasks, Task # I'm commented
    many_to_many :tasks, Task, join_through: "users_tasks" # I'm new!
    has_one :credential, Credential
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
```
Thats all for the 'difficult' many-to-many relationship. Run the migrations once again for the changes to take effect.

## Saving associations
Besides creating the associations in the migrations and schema's we also need a way to input those associations into the database. This can be done:

1. Using `put_assoc/3` if the associated entry does already exist in the database. _(not implemented in the demo)_
```Elixir
  @doc false
  def changeset(user, attrs, %Credentials{} = credentials) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
    |> put_assoc(:credentials, credentials)
  end
```

2. Using `cast_assoc/3` if the associated entry is not yet created. 

```Elixir
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
    |> cast_assoc(:credentials)
  end
```
 This approach expects the attrs to contain the user information. In order to achieve this we can make use of a special Phoenix.HTML helper named `inputs_for/4`. We will change the user form template to make use of this helper to create both the user and the credentials entity in one go.

 ```html
 <%= form_for @changeset, @action, fn f -> %>
  <%= if @changeset.action do %>
    <div class="alert alert-danger">
      <p>Oops, something went wrong! Please check the errors below.</p>
    </div>
  <% end %>
  <%= label f, :name %>
  <%= text_input f, :name %>
  <%= error_tag f, :name %>

  <%= label f, :age %>
  <%= number_input f, :age %>
  <%= error_tag f, :age %>
  <!-- start new -->
  <%= inputs_for f, :credential, fn c -> %>
      <%= label c, :username, class: "w3-text-black w3-left" %>
      <%= text_input c, :username, class: "w3-input w3-border" %>
      <%= error_tag c, :username %>

      <%= label c, :password, class: "w3-text-black w3-left" %>
      <%= text_input c, :password, class: "w3-input w3-border" %>
      <%= error_tag c, :password %>
  <% end %>
 <!-- end new -->
  <div>
    <%= submit "Save" %>
  </div>
<% end %>

 ```

<!-- markdown-link-check-disable -->
 If we start the server and go to [http://localhost:4000/users/new](http://localhost:4000/users/new) we can see the extra username and password form field. When we fill in everything and press save, both the user and credentials will be saved seperately. Take a look at your database to confirm this.
 <!-- markdown-link-check-enable -->

## Retrieving associations
The last important aspect of associations is the possibility of retrieving associated data. When requesting an entry from the database non of it's associations are loaded by default (`#Ecto.Association.NotLoaded<association :projects is not loaded>`) You can verify this using `IEx.pry()`. Loading associations can be done fairly easily using `preload/3`.

For example to load the credentials of a user we can add the following line of code. The returned structure contains the credentials instead of the not loaded associations. 

```Elixir
new_user = Repo.preload(user, [:credential])
```

Keep in mind that elixir is a functional programming language meaning that `user` still contains the _non loaded associations_ while `new_user` does contain the _loaded credentials_.

