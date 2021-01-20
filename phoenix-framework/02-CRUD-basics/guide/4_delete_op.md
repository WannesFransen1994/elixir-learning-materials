# Delete operation

Same thing all over again.

In your context define delete logic:

```elixir
  @doc "Delete a user"
  def delete_user(%User{} = user), do: Repo.delete(user)
```

In your `router.ex` add a delete route:

```Elixir
    delete "/users/:user_id", UserController, :delete
```

Now that we have all crud routes, we can just replace it with the `resources` macro. 

```Elixir
    get "/users/new", UserController, :new
    post "/users", UserController, :create
    get "/users", UserController, :index
    get "/users/:user_id", UserController, :show
    get "/users/:user_id/edit", UserController, :edit
    put "/users/:user_id", UserController, :update
    patch "/users/:user_id", UserController, :update
    delete "/users/:user_id", UserController, :delete
```
Is equivalent with:

```Elixir
    resources("/users", UserController)
```

In your `apps/user_demo_web` app you can run the `mix phx.server` command and see all supported routes.

Add this to your controller:

```elixir
  def delete(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
```

And add this to e.g. your `index.html.eex`, again for every user:

```html
    <span><%= link "Delete", to: Routes.user_path(@conn, :delete, user),
        method: :delete, data: [confirm: "Are you sure?"] %></span>
```

And you're all set!

CRUD operations can be simplified using phoenix generators. Running following HTML generator will automatically create everything discussed in this guide.
```bash
  # Generates an Ecto schema and migration.
  mix phx.gen.schema UserContext.User users name:string age:integer

  # Generates an Ecto schema, migration, controller, views, and context for a JSON resource.
  mix phx.gen.json UserContext User users name:string age:integer
  
  # Generates an Ecto schema, migration, controller, views, context and templates for an HTML resource
  mix phx.gen.html UserContext User users name:string age:integer
```
