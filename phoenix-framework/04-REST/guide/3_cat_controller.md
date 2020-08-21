# Controller & Routes

## Routes - nested resources

Now that we have our (unfinished) context, schema and migration, we can go ahead and configure our routes. Because the user will want to configure his/her own cats, we'll need to generate some url that communicates this clearly in code and to the user. An example would be `/users/:user_id/cats` or `/users/:user_id/cats/:id/edit`. We can achieve this easily with [nested resources](https://hexdocs.pm/phoenix/routing.html) in our `router.ex`.

Though we could easily generate a html version for the cat CRUD operations, we want these to only be editable through a REST endpoint. 

## Router scopes

To put it shortly, we can use [scoped routes](https://hexdocs.pm/phoenix/routing.html#scoped-routes) to group routes under a common path prefix with certain plugs. Several examples would be:

* `/admin` scope that requires extra permissions
* `/user` scope that needs authentication
* `/api` scope to configure our requests not for html (`:browser` pipeline), but for JSON requests

We've already got a great example for the root path, let's create a new scope for `/api` and pipe it through our `:api` pipeline.

```elixir
  scope "/", UserCatsWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
  end

  scope "/api", UserCatsWeb do
    pipe_through :api

    resources "/users", UserController, only: [] do
      resources "/cats", CatController
    end
  end
```

You can see that we created nested resources in the above code snippet. Though it seems that there's a lot of magic happening here, let us quickly go over this:

* scope "/" -> resources "/users" => is for the html interface to edit our users.
* scope "/api" -> resources "/users", only: [] => means that we're generating routes for our user as well. Thanks to the [resources macro](https://hexdocs.pm/phoenix/Phoenix.Router.html#resources/4), we can configure this and say that we don't want REST routes for the users resource.
* resources "/cats", CatController => means that we're going to allow (nested if it is inside another resources block) cat routes for our REST API.

## Pipelines

We've seen these [pipelines](https://hexdocs.pm/phoenix/routing.html#pipelines) several times now already, but what are these exactly?

Our request arrives and the endpoint and needs to go through a lot of tranformations so that we can start using it. These transformations are done with plugs.

### Plug

A plug is a module that enforces certain rules or operations and can transform the request based on them.

We can naively represent a request flow like this:

```elixir
connection
|> endpoint()
|> router()
|> pipelines()
|> controller()
```

Where Endpoint already defines some plugs by default:

```elixir
defmodule MyApp.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app
  plug Plug.Static, ...
  plug Plug.RequestId
  plug Plug.Telemetry, ...
  plug Plug.Parsers, ...
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, ...
  plug MyApp.Router
end
```

As we can see, there are already a lot of plugs being used on the background. As soon as you want to custom configure plugs groups, you can configure it in your router pipelines, such as the preconfigured `:api` and `:browser`.

Later on we'll make our own plugs. For now just know that they exist and that you use them indirectly.

### Displaying our routes

Feel free display your routes with:

```bash
mix phx.routes
# ONLY OUTPUTTING API ROUTES HERE
 GET     /api/users/:user_id/cats           CatController :index
 GET     /api/users/:user_id/cats/:id/edit  CatController :edit
 GET     /api/users/:user_id/cats/new       CatController :new
 GET     /api/users/:user_id/cats/:id       CatController :show
 POST    /api/users/:user_id/cats           CatController :create
 PATCH   /api/users/:user_id/cats/:id       CatController :update
 PUT     /api/users/:user_id/cats/:id       CatController :update
 DELETE  /api/users/:user_id/cats/:id       CatController :delete
```

We can see that we've got nested routes, and no user REST CRUD routes, which is exactly what we want.

## Creating the controller

Considering it is very similar to our other controller, let's copy the template.

```elixir
defmodule UserCatsWeb.CatController do
  use UserCatsWeb, :controller

  def index(conn, _params), do: # ...
  def create(conn,_params), do: # ...
  def show(conn, _params), do: # ...
  def update(conn, _params), do: # ...
  def delete(conn, _params), do: # ...
end
```

## Create the view

While we could just dump a JSON response back from our controller action, let's do this properly with view. Create a view like so:

```elixir
defmodule UserCatsWeb.CatView do
  use UserCatsWeb, :view
end
```

Later on we'll configure this a bit more, we'll come back to that.

### Our create operation

#### `C`RUD: Adjusting our context and schema

First we adjust our schema. We create a specific changeset for the create operation. Know that there are many ways to do this, but personally I like this approach.

```elixir
defmodule UserCats.CatContext.Cat do
  # ...

  def create_changeset(cat, attrs, user) do
    cat
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_assoc(:user, user)
  end
end
```

As you can see we've putted a `put_assoc/3` function. You can find an overview when you want to use `cast_assoc/3` or other options at [this link](https://ezcook.de/2018/05/15/cast-assoc/).

Now we'll adjust our context to use this as well. If we know that we'll need a user to create the cat, we just add this as a parameter in our context like so:

```elixir
  def create_cat(attrs, %User{} = user) do
    %Cat{}
    |> Cat.create_changeset(attrs, user)
    |> Repo.insert()
  end
```

That should be quite obvious, next is the controller.

#### `C`RUD: Adjusting our controller

We'll once again do some straightforward stuff. First we get the user, after which we try to create the cat based on the given parameters. Your code should look like:

```elixir
  def create(conn, %{"user_id" => user_id, "cat" => cat_params}) do
    user = UserContext.get_user!(user_id)

    case CatContext.create_cat(cat_params, user) do
      {:ok, %Cat{} = cat} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_cat_path(conn, :show, user_id, cat))
        |> render("show.json", cat: cat)

      {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
    end
  end
```

### Our read operation

#### C`R`UD: Adjusting our context

When we go to the path `/users/:user_id/cats`, we don't want to see all the cats but only the cats for that specific user. Let us first of all adjust our context to do this:

```elixir
  alias UserCats.UserContext.User
  def load_cats(%User{} = u), do: u |> Repo.preload([:cats])
```

This way we make sure that we load the cats of a user. Know that when you get an entity from the database, default its associations are not loaded, which you'll have to do with `Repo.preload`.

#### C`R`UD: Adjusting our controller

When we know that this is possible, let us adjust our index and show method like so:

```elixir
  def index(conn, %{"user_id" => user_id}) do
    user = UserContext.get_user!(user_id)
    user_with_loaded_cats = CatContext.load_cats(user)
    render(conn, "index.json", cats: user_with_loaded_cats.cats)
  end

  def show(conn, %{"id" => id}) do
    cat = CatContext.get_cat!(id)
    render(conn, "show.json", cat: cat)
  end
```

As you can see, we first retrieve our user, then preload our cats, after which we want to format this in the view. The only problem is that our view doesn't support this yet. Let us do that now.

#### C`R`UD: Adjusting our view

We'll often want to filter our data that we display to our users. This can of course be done in the controller, but the view is the place to do this. In the view we configure how we, yes you guessed it, view the data.

```elixir
  def render("index.json", %{cats: cats}) do
    %{data: render_many(cats, CatView, "cat.json")}
  end

  def render("show.json", %{cat: cat}) do
    %{data: render_one(cat, CatView, "cat.json")}
  end

  def render("cat.json", %{cat: cat}) do
    %{id: cat.id, name: cat.name}
  end
```

### Our update operation

Most of the context operations are already generated, hence we can just focus on our controller.

#### CR`U`D: Adjusting our controller

Similar to our create method, we'll receive some params and a cat id to adjust. First we'll retrieve the cat, and then update it. Because we're not changing associations, we can use the default changeset from the schema in the context.

Your controller should look like:

```elixir
  def update(conn, %{"id" => id, "cat" => cat_params}) do
    cat = CatContext.get_cat!(id)

    case CatContext.update_cat(cat, cat_params) do
      {:ok, %Cat{} = cat} ->
        render(conn, "show.json", cat: cat)

      {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
    end
  end
```

### Our delete operation

Same story as our update operation, most of it is already there. We just need to adjust our controller.

#### CRU`D`: Adjusting our controller

Principles are the same, first fetch the cat and then delete it based on the already existing method in the context.

Your controller should look like:

```elixir
  def delete(conn, %{"id" => id}) do
    cat = CatContext.get_cat!(id)

    with {:ok, %Cat{}} <- CatContext.delete_cat(cat) do
      send_resp(conn, :no_content, "")
    end
  end
```

## Testing your API with postman

In the git repo should be a folder `demo/postman_api_calls_export`. You need to be able to use this software on the exam as well.

## Extra

All of this could've mostly be done with `mix phx.gen.json` command. Though you still need to manually make the associations.
