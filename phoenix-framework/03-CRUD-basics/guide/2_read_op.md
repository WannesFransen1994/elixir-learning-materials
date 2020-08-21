# Read operation

These are rather simple operations. First allow our `UserContext` to fetch all our users and get a specific user.

```elixir
  @doc "Returns a specific user or raises an error"
  def get_user!(id), do: Repo.get!(User, id)

  @doc "Returns all users in the system"
  def list_users, do: Repo.all(User)
```

Then we add the according routes in our `router.ex`.

```elixir
    get "/users", UserController, :index
    get "/users/:user_id", UserController, :show
```

After which we create the actions in our controller:

```elixir
  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end
```

Above actions should be self-explanatory. Next up are the `index.html.eex` and `show.html.eex` pages.

```html
<h1>Listing Users</h1>

<table>
    <thead>
        <tr>
            <th>first name</th>
            <th>last name</th>
            <th>date of birth</th>

            <th></th>
        </tr>
    </thead>
    <tbody>
        <%= for user <- @users do %>
        <tr>
            <td><%= user.first_name %></td>
            <td><%= user.last_name %></td>
            <td><%= user.date_of_birth %></td>

            <td>
                <span><%= link "Show", to: Routes.user_path(@conn, :show, user) %></span>
            </td>
        </tr>
        <% end %>
    </tbody>
</table>

<%= link "New user", 
to: Routes.user_path(@conn, :new) %>
```

```html
<h1>Show User details</h1>

<ul>
    <li>
        <strong>First name:</strong>
        <%= @user.first_name %>
    </li>

    <li>
        <strong>Last name:</strong>
        <%= @user.last_name %>
    </li>

    <li>
        <strong>date of birth:</strong>
        <%= @user.date_of_birth %>
    </li>
</ul>

<%= link "Back", to: Routes.user_path(@conn, :index) %>
```

That's all there is to it. On to updating user details.
