# Delete operation

Same thing all over again. You get it now don't you?

In your context:

```elixir
  @doc "Delete a user"
  def delete_user(%User{} = user), do: Repo.delete(user)
```

In your `router.ex`:

```elixir
    delete "/users/:user_id", UserController, :delete
```

Now that we have all crud routes, we can just replace it with the `resources` macro. We did this in the previous lesson, now you know what it does. In your `apps/user_demo_web` app you can run the `mix phx.server` command and see all supported routes.

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

And add this to e.g. your `index.html.eex`:

```html
    <span><%= link "Delete", to: Routes.user_path(@conn, :delete, user),
        method: :delete, data: [confirm: "Are you sure?"] %></span>
```

And you're all set!

Know that you can autogenerate all these files with the `mix phx.gen.html` command.
