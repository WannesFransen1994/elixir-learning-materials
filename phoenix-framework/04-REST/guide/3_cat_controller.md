# Controller & Routes

## Routes - nested resources

Now that we have our (unfinished) context, schema and migration, we can go ahead and configure our routes. Because the user wants to configure his/her own cats, we'll need to generate some url that communicates this clearly in code and to the user. An example would be `/users/:user_id/cats` or `/users/:user_id/cats/:id/edit`. We can achieve this easily with [nested resources](https://hexdocs.pm/phoenix/routing.html) in our `router.ex`.

Though we could easily generate a html version for the cat CRUD operations, we want these to only be editable through a REST endpoint.

## Router scopes

To put it shortly, we can use [scoped routes](https://hexdocs.pm/phoenix/routing.html#scoped-routes) to group routes under a common path prefix with certain plugs. Several examples would be:

* `/admin` scope that requires extra permissions
* `/user` scope that needs authentication
* `/api` scope to configure our requests not for html, but for JSON requests

We've already got a great example for the root path, let's create a new scope for `/api` and pipe it through our `:api` pipeline. To should be done in the router.ex file within the *_web folder.

```elixir
  scope "/", UserCatsRefWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
  end

  scope "/api", UserCatsRefWeb do
    pipe_through :api

    resources "/users", UserController, only: [] do
      resources "/cats", CatController
    end
  end
```

You can see that we created nested resources in the above code snippet. Though it seems that there's a lot of magic happening here, let us quickly go over this:

* scope "/" -> resources "/users" => is for the html interface to edit our users.
* scope "/api" -> resources "/users", only: [] => means that we're generating routes for our user as well. Thanks to the [resources macro](https://hexdocs.pm/phoenix/Phoenix.Router.html#resources/4), we can configure this. Using `only: []` we specify that we don't want REST routes for the users resource.
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

Feel free display your routes with  `mix phx.routes` in the user_cats_ref_web folder

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

We can see that we've got nested routes, and no user REST CRUD routes, which is exactly what we want. Also take a close look at the parameter names. The latest parameter is always called `:id` with previous parameters are named after the controller `:user_id`. This is usefull when pattern matching in the controller!

## Creating the controller

Create a new controller file for the cat_contoller named `cat_controller.ex`. Considering it is very similar to our other controller, let's copy the template and already include some alias.

```elixir
defmodule UserCatsRefWeb.CatController do
  use UserCatsRefWeb, :controller

  alias UserCatsRef.UserContext

  alias UserCatsRef.CatContext
  alias UserCatsRef.CatContext.Cat

  def index(conn, _params), do: # ...
  def create(conn,_params), do: # ...
  def show(conn, _params), do: # ...
  def update(conn, _params), do: # ...
  def delete(conn, _params), do: # ...
end
```

## Create the view

While we could just dump a JSON response back from our controller action, let's do this properly with view. 

Create a new view, notice that the name of the view module should exactly match the controller name. Also the name of the view file is important to use the same pattern. In our case the file should be name `cat_view.ex`

```elixir
defmodule UserCatsRefWeb.CatView do
  use UserCatsRefWeb, :view
end
```

Later on we'll configure the view a bit more, we'll come back to that.

### Our create operation

#### `C`RUD: Adjusting our context and schema

First we adjust our schema (schema's are always in the user_cats_ref/lib/user_cats_ref folder). We add a specific changeset for the create operation of cats. Know that there are many ways to do this.

```elixir
defmodule UserCatsRef.CatContext.Cat do
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

Now we'll adjust our context (context's are always in the user_cats_ref/lib/user_cats_ref folder) to use this as well. If we know that we'll need a user to create the cat, we just add this as a parameter in our context. The create_cat function is already there, adjust it like so:

```elixir
  def create_cat(attrs, %User{} = user) do
    %Cat{}
    |> Cat.create_changeset(attrs, user)
    |> Repo.insert()
  end
```

#### `C`RUD: Adjusting our controller
Next we have to implement the `cat_controller.ex` template we created earlier. The controller is part of the *_web app so the controller is always found in that folder.

Notice that the `_params` from the template is changed to match the routes. Remember that `mix phx.routes` shows us all available routes with the parameter names (`:user_id`) to match. 

Your code should look like:

```elixir
  def create(conn, %{"user_id" => user_id, "cat" => cat_params}) do
    user = UserContext.get_user!(user_id) #Get the user structure based on its user_id

    case CatContext.create_cat(cat_params, user) do # Call create_cat function from the CatContext
      {:ok, %Cat{} = cat} -> # If creation was successful, let the end user know about the creation
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_cat_path(conn, :show, user_id, cat))
        |> render("show.json", cat: cat) #Notice the show.json instead of show.html! show.json does not yet exists but will be created later in this guide.

      {:error, _cs} -> # If creation failed, let the end user know about the failure.
        conn
        |> send_resp(400, "Something went wrong, sorry.")
    end
  end
```

_Create should not yet work as `show.json` is not there yet._

### Our read operation

#### C`R`UD: Adjusting our context

When we go to the path `/users/:user_id/cats`, we don't want to see all the cats but only the cats for that specific user. Let us first of all adjust our cat_context (Do you already know where to find this file?) to do this. This function is not in the context yet so you should create it yourself.

```elixir
  alias UserCatsRef.UserContext.User
  def load_cats(%User{} = u), do: u |> Repo.preload([:cats])
```

This way we make sure that we load the cats of a user. Know that when you get an entity from the database, default its associations are not loaded, which you'll have to do with `Repo.preload`.

#### C`R`UD: Adjusting our controller

Back to the controller, controllers are part of the web app so they are located within the *_web folder. 

Let us adjust in the cat_controller template our index and later the show method for the cats.

```elixir
  def index(conn, %{"user_id" => user_id}) do
    user = UserContext.get_user!(user_id) # Retrieve the user with the given user_id
    user_with_loaded_cats = CatContext.load_cats(user) #Add the cats to the given user. As elixir is a functional programming language, user will not be updated but a new structure is returned. 
    render(conn, "index.json", cats: user_with_loaded_cats.cats) #Render the cats following index.json.
  end
```

As you can see, we first retrieve our user, then preload our cats, after which we want to format this in the view. The only problem is that our view doesn't support this yet. Let us do that next.


```elixir
  def show(conn, %{"id" => id}) do
    cat = CatContext.get_cat!(id) # retrieve the cat by the given id.
    render(conn, "show.json", cat: cat) #render the cat following show.json
  end
```

_notice that the show function does not really care about the given user_id, this can lead to unauthorized access to resources which is unwanted is most cases but not in scope of this guide._

#### C`R`UD: Adjusting our view
The view is part of the web application so it is located in the *_web folder.

We'll often want to filter our data that we display to our users. This can of course be done in the controller, but the view is the place to do this. In the view we configure how we, yes you guessed it, view the data.

```elixir
  
  alias UserCatsRefWeb.CatView

  def render("index.json", %{cats: cats}) do 
    %{data: render_many(cats, CatView, "cat.json")} # Create a json with key = data & value = an array of cats. The render_many is used to call render on every attribute in the (cats)-list
  end

  def render("show.json", %{cat: cat}) do
    %{data: render_one(cat, CatView, "cat.json")} #Create a json with key = data & value = a dictionary of a single cat.
  end

  def render("cat.json", %{cat: cat}) do # render(show.json, cat) & render(index.json, cats) call this function to know how to exactly create a json of a cat attribute.
    %{id: cat.id, name: cat.name}
  end
```

### Our update operation

All of the context operations are already generated/implemented, hence we can just focus on our controller.

#### CR`U`D: Adjusting our controller

Similar to our create method, we'll receive some params and a cat id to adjust. First we'll retrieve the cat, and then update it. Because we're not changing associations, we can use the default changeset from the schema in the context.

Your controller should look like:

```elixir
  def update(conn, %{"id" => id, "cat" => cat_params}) do
    cat = CatContext.get_cat!(id) # Get the cat from the database

    case CatContext.update_cat(cat, cat_params) do # Update the cat
      {:ok, %Cat{} = cat} -> # If the update was succesful, show the end user the updated cat
        render(conn, "show.json", cat: cat)

      {:error, _cs} -> # If the update failed, notify the end user about the failure
        conn
        |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
    end
  end
```

_notice that the update function does not really care about the given user_id, this can lead to unauthorized access to resources which is unwanted is most cases but not in scope of this guide._

### Our delete operation

Same story as our update operation, all of it is already there in the context. We just need to adjust our controller.

#### CRU`D`: Adjusting our controller

Principles are the same, first fetch the cat and then delete it based on the already existing method in the context.

Your controller should look like:

```elixir
  def delete(conn, %{"id" => id}) do
    cat = CatContext.get_cat!(id) # Get the cat from the database

    case CatContext.delete_cat(cat) do # Delete the cat from the database
    {:ok, %Cat{}} ->  #If delete sucessfull, send a 200 message
            send_resp(conn, :no_content, "")
    {:error, _cs} ->   # If delete failed, notify the end user about the failure
        conn
        |> send_resp(400, "Something went wrong, sorry.")
    end
  end
```

_notice that the update function does not really care about the given user_id, this can lead to unauthorized access to resources which is unwanted is most cases but not in scope of this guide._

## Testing your API with postman

There should be a folder `demo/postman_api_calls_export` to test the API-calls. You can also create your own API-calls with postman

## Extra

All of this could've mostly be done with `mix phx.gen.json` command. Though you still need to manually make the associations.


### retake C`R`UD cat controller:

Now that we have a working project, lets take a closer look at the difference betwee `user` & `user_with_loaded_cats`. We can do this easily with `require IEx; IEx.pry`. This will pauze exection so that you can look at all the parameters at the execution point and look at the differences.

Adjust the index function in the cat_controller as followed:

```elixir
  def index(conn, %{"user_id" => user_id}) do
    user = UserContext.get_user!(user_id) # Retrieve the user with the given user_id
    user_with_loaded_cats = CatContext.load_cats(user) #Add the cats to the given user. As elixir is a functional programming language, user will not be updated but a new structure is returned. 
    require IEx;
    IEx.pry
    render(conn, "index.json", cats: user_with_loaded_cats.cats) #Render the cats following index.json.
  end
```

Start the server with an interactive session and send a GET index request to `localhost:4000/api/users/1/cats` via postman. As you will see the request will take a very very very long time, this because execution is pauzed. Go to the terminal which started the server and you will see a Pry request. Allow this Pry request with `Y` and type `user` to view the user attribute. Next type `user_with_loaded_cats` to view this attribute and look at the difference.

The user as a parameter cats which is `#Ecto.Association.NotLoaded<association :cats is not loaded>` whilce the user_with_loaded_cats has a list of cats which are loaded. The original user has not changed as those changes are impossible in a functional programming language.

Delete `require IEx; IEx.pry` to not pauze execution with every request.
