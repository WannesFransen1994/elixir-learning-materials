# AuthZ

## What we already have

Just to sum it up:

* User resource with a certain role
* Login mechanism
* Authentication pipeline
* Automatically loaded user resources thanks to the loadresource plug
* Protected routes

## Adjusting our router

In order to illustrate role-based authentication, we'll go further with our protected routes and define 3 scopes (based on the role).

* User scope
* Manager scope
* Admin scope (will be able to create/delete users)

We'll want to have a router file similar to:

```elixir
  pipeline :allowed_for_users do
    plug AuthWeb.Plugs.AuthorizationPlug, ["Admin", "Manager", "User"]
  end

  pipeline :allowed_for_managers do
    plug AuthWeb.Plugs.AuthorizationPlug, ["Admin", "Manager"]
  end

  pipeline :allowed_for_admins do
    plug AuthWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", AuthWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/", AuthWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/user_scope", PageController, :user_index
  end

  scope "/", AuthWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_managers]

    get "/manager_scope", PageController, :manager_index
  end

  scope "/admin", AuthWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources "/users", UserController
    get "/", PageController, :admin_index
  end
```

As you can wee we have 3 scopes, each one is for a specific role. While one could achieve results in a single scope and certain "policies", we'll go for our custom solution. You can see that we have a custom plug, the `AuthWeb.Plugs.AuthorizationPlug`, which takes some options.

## Creating our plug

We've seen plugs in action several times already. As you can see it'll transform the request several times until it is returned back as a response. An illustration of this proces could be found [here](https://www.brianstorti.com/assets/images/plug.png).

We'll write our own plug which checks whether a user has enough roles. Of course you don't want to write a plug for each role (e.g. "IsAdminPlug"), hence the use of the options in our router. An example plug would be:

```elixir
defmodule AuthWeb.Plugs.AuthorizationPlug do
  import Plug.Conn
  alias Auth.UserContext.User
  alias Phoenix.Controller

  def init(options), do: options

  def call(%{private: %{guardian_default_resource: %User{} = u}} = conn, roles) do
    conn
    |> grant_access(u.role in roles)
  end

  def grant_access(conn, true), do: conn

  def grant_access(conn, false) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: "/")
    |> halt
  end
end
```

Here you can see 2 necessary callbacks and a custom multi-clause function. The `init/1` callback takes the options and does necessary transformations. This is often nothing, as you'll use the result of the `init/1` function and use it as the 2nd argument of the `call/2` function. **The init function is called during compile time**, while the `call/2` callback is the workhorse.

We can also [halt](https://hexdocs.pm/plug/Plug.Builder.html#module-halting-a-plug-pipeline) a pipeline when we see fit. In this case, we'll want to halt it when the user doesn't have access to those resources. This doesn't mean that we don't give a response, as we nicely redirect the user to the index page (or somewhere else). _If you don't do this, you'll get the common "response already sent" error._

## Role specific resources

In order to demonstrate specific roles, we'll use a page that'll print for who it should be visible. This'll be really basic, so we'll reuse the home page and just display our role.

### Adjusting our templates

```html
<!-- templates/layout/app.html.eex -->
      ...
      <nav role="navigation">
        <ul>
          <li><a href="/">Home</a></li>
          <li><a href="<%= Routes.user_path(@conn, :index) %>">Users</a></li>
          <li><a href="<%= Routes.session_path(@conn, :new) %>">Login</a></li>
          <li><a href="<%= Routes.session_path(@conn, :logout) %>">Logout</a></li>
          <li><a href="/user_scope">User scope</a></li>
          <li><a href="/manager_scope">Manager scope</a></li>
          <li><a href="/admin">Admin scope</a></li>
        </ul>
      </nav>
      ...
```

```html
<!-- templates/page/index.html.eex -->
<section class="phx-hero">
  <h1><%= gettext "Welcome to %{name}!", name: "Phoenix" %></h1>
  <p>A productive web framework that<br />does not compromise speed or maintainability.</p>
</section>

<section class="row">
  this page is for: <%= @role %>
  <br>
  user accounts with password "t":
  <br>
  user - manager - admin
</section>
```

### Adjusting our controller

As we've already seen what our router expects, let us quickly implement the necessary actions in our controller.

```elixir
defmodule AuthWeb.PageController do
  use AuthWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", role: "everyone")
  end

  def user_index(conn, _params) do
    render(conn, "index.html", role: "users")
  end

  def manager_index(conn, _params) do
    render(conn, "index.html", role: "managers")
  end

  def admin_index(conn, _params) do
    render(conn, "index.html", role: "admins")
  end
end
```

This should be enough to do role-based authorization! You can get only so far with custom-making all of your plugs. As soon as you have more complex scenarios, you should consider using a library such as bodyguard.
