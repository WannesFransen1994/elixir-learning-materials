# Setup demo - the user has cats project

We're not going to waste time here, instead of creating all our previous resources manually we'll generate them using build in generators. Execute the following commands:

```bash
 $> mix phx.new user_cats_ref --umbrella --database mysql
 $> mix phx.gen.html UserContext User users first_name:string last_name:string date_of_birth:date # In apps/user_cats_ref_web folder
 $> # Adjust your config/dev.exs config file for db access.
 $> mix ecto.reset # Run in apps/user_cats_ref in order to create the database and run the migrations.
```
As written in the terminal output after generating the context we have to manually add the following to the router:

```elixir
resources "/users", UserController
```

Fire up your dev server from the main folder with `iex -S mix phx.server` and go manually to the url `localhost:4000/users`. You should be able to do the CRUD operations on your `User` entity.

Next we'll go and configure our REST endpoint for editing our cats.
