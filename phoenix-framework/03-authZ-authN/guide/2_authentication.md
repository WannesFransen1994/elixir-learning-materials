# AuthN

As covered in the theory classes, we'll use JWT over Sessions for now. Following libraries are quite popular at the time of writing:

* Guardian: Token based AuthN (default JWT)
* Pow: Traditional session based authentication

## Providing a way to authenticate

Before we start implementing our Guardian modules, let us first implement a way so that we can verify when logging in whether a provided username and password is correct or not. We'll provide this method in our `UserContext`.

```elixir
  def authenticate_user(username, plain_text_password) do
    case Repo.get_by(User, username: username) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Argon2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
```

You might wonder why we call the `Argon2.no_user_verify/0` function when we can't find a user. This is to make it more difficult for attackers to retrieve usernames based on timing attacks. When a user is found it'll verify the password.

## Setup Guardian

### Adding the depencency

In our `apps/auth_web` project its `mix.exs` file, add the following dependency:

```elixir
{:guardian, "~> 2.0"}
```

Remember to run `mix deps.get` after adjusting this file.

### Implementation module

Because we want to pattern match on our `get_user/1` function, we don't want to use the bang version that's generated in our `UserContext`. Let us implement another one:

```elixir
  # UserContext
  def get_user(id), do: Repo.get(User, id)
```

We'll also need to have some kind of implementation module in order to tell Guardian how we identify our token and how it should retrieve this resource. We do that with an implementation module like so:

```elixir
defmodule AuthWeb.Guardian do
  use Guardian, otp_app: :auth_web

  alias Auth.UserContext
  alias Auth.UserContext.User

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case UserContext.get_user(id) do
      %User{} = u -> {:ok, u}
      nil -> {:error, :resource_not_found}
    end
  end
end
```

The `resource_from_claims/1` function allows us to retrieve our resource from a specific "claim" in our JWT. First let us take a look as to what we exectly get from arguments: (you'll be able to do this as well when everything works.)

```elixir
%{
  "aud" => "auth_web",
  "exp" => 1584137319,
  "iat" => 1581718119,
  "iss" => "auth_web",
  "jti" => "0425b8dd-d40c-42a5-943b-dbf2e87f9943",
  "nbf" => 1581718118,
  "sub" => "3",
  "typ" => "access"
}
```

A lot of these claims are documented by the IETF (open standards organization), you can read all about them in [this link](https://tools.ietf.org/html/rfc7519#section-4.1). What we are interested in, is the `sub` field which contains our user ID. It got there because of the `subject_for_token/1` function, where we put the user ID as the subject.

### Setting up our config

In order to sign our JWT tokens, we'll need a secret. You can generate this with `mix guardian.gen.secret`. Add this to your config like so:

```elixir
config :auth_web, AuthWeb.Guardian,
  issuer: "auth_web",
  secret_key: "" # paste input here
```

_Note that `auth_web` is our project name!_

### Setting up an error handler

We're also going to define a errorhandler in case there's an authentication failure. One of the most basic ones is this:

```elixir
defmodule AuthWeb.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    send_resp(conn, 401, body)
  end
end

```

This just dumps a message to our screen. Feel free to personalize this with error messages, redirections, etc... .

### Setting up our (module) pipeline

We can already see a default-generated pipeline in our `router.ex`. This is a pipeline constructed in our routes based on a collection of plugs. It is also possible to make a module into a plug and use that as a pipeline like so:

```elixir
defmodule AuthWeb.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :auth_web,
    error_handler: AuthWeb.ErrorHandler,
    module: AuthWeb.Guardian

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
```

We see that loading the resource is optional, as we'll have an index page on which it doesn't matter whether the user is logged in or not. (Though you may want to hide/show login/logout buttons depending on this.) Later on we'll restrict this further.

After defining our pipeline, we add this to our `router.ex` with one extra pipeline:

```elixir
  pipeline :auth do
    plug AuthWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end
```

The second one is quite self-explanatory, but it just verifies whether you are authenticated or not.

## Configuring our routes

With two useful pipelines, let us configure our routes so that we have our user resources protected:

```elixir
  scope "/", AuthWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/admin", AuthWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/users", UserController
  end
```

## Making our session controller

While the naming may be treacherous, remind that we're using __JWT and not sessions__. Though as far as the user is concerned, he'll log in and after a time he'll have to reconfirm / log in again. This behavior, or maybe better worded as purpose, is a lot like a session.

We've seen the underlying mechanisms of controllers already. It'll look like the following:

```elixir
defmodule AuthWeb.SessionController do
  use AuthWeb, :controller

  alias AuthWeb.Guardian
  alias Auth.UserContext
  alias Auth.UserContext.User

  def new(conn, _) do
    changeset = UserContext.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/user_scope")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    UserContext.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/user_scope")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
```

## Making our template

### First the view

We'll make a simple session view.

```elixir
defmodule AuthWeb.SessionView do
  use AuthWeb, :view
end
```

### Login template

```html
<!-- templates/session/new.html.eex -->
<h2>Login Page</h2>

<%= form_for @changeset, @action, fn f -> %>

<div class="form-group">
    <%= label f, :username, class: "control-label" %>
    <%= text_input f, :username, class: "form-control" %>
    <%= error_tag f, :username %>
</div>

<div class="form-group">
    <%= label f, :password, class: "control-label" %>
    <%= password_input f, :password, class: "form-control" %>
    <%= error_tag f, :password %>
</div>

<div class="form-group">
    <%= submit "Submit", class: "btn btn-primary" %>
</div>
<% end %>
```

### Properly configuring our routes

We'll do this in the next section. If you run your app now, you'll have to put in some URL's manually.
