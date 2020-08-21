# Setup demo - the user has cats project

We're not going to waste time here, instead of creating all our previous resources manually we'll generate them. Execute the following commands:

```bash
 $> mix phx.new user_cats_ref --umbrella --database mysql --no-webpack
 $> mix phx.gen.html UserContext User users first_name:string last_name:string date_of_birth:date
 $> # Adjust your dev.exs config file for db access.
```

Add the following to your router:

```elixir
resources "/users", UserController
```

Fire up your dev server with `mix phx.server` and go manually to the url `localhost:4000/users`. You should be able to do the CRUD operations on your `User` entity.

Next we'll go and configure our REST endpoint for editing our cats.
