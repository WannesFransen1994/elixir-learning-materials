# Update operation

Similar to our previous operations, let us first adjust our context.

```elixir
  @doc "Update an existing user with external attributes"
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
```

After which we'll have to provide 2 (or 3) extra routes:

```elixir
    get "/users/:user_id/edit", UserController, :edit
    put "/users/:user_id", UserController, :update
    patch "/users/:user_id", UserController, :update
```

Then we'll create the actions in our controller:

```elixir
  def edit(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user_id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
```

If you understand the code to create a user completely, above code should be self-explanatory as well. As for the update form, we'll re-use the form that we wrote to create a user.

First of all let us edit the `index.html.eex` file by adding an edit link.

```html
<span><%= link "Edit", to: Routes.user_path(@conn, :edit, user) %></span>
```

Add this to every row as there should be an edit option for every user. Another link to the show page can also be includes as well if you want to. Then let us create the `form.html.eex` page:

```html
<%= form_for @changeset, @action, fn f -> %>
<%= if @changeset.action do %>
<div class="alert alert-danger">
    <p>Oops, something went wrong! Please check the errors below.</p>
</div>
<% end %>

<%= label f, :first_name %>
<%= text_input f, :first_name %>
<%= error_tag f, :first_name %>

<%= label f, :last_name %>
<%= text_input f, :last_name %>
<%= error_tag f, :last_name %>

<%= label f, :date_of_birth %>
<%= date_select f, :date_of_birth, year: [options: 1910..2020] %>
<%= error_tag f, :date_of_birth %>

<div>
    <%= submit "Save" %>
</div>
<% end %>
```
The only change, compared to `new.html.eex`, is that this html file contains the `@action` variable. When rendering our form from `new.html.eex` or `edit.html.eex`, we'll pass different actions to this variable making the `form.html.eex` file be used by both pages.

```html
<h1>New User</h1>


<%= render "form.html", Map.put(assigns, :action, Routes.user_path(@conn, :create)) %>

<span><%= link "Back", to: Routes.user_path(@conn, :index) %></span>
```

```html
<h1>Edit user</h1>

<%= render "form.html", Map.put(assigns, :action, Routes.user_path(@conn, :update, @user)) %>

<span><%= link "Back", to: Routes.user_path(@conn, :index) %></span>
```

The `assigns` variable is actually something in our `conn` variable. We get this as a parameter in our controller action. We're storing all kinds of things there!

There we go, now we can edit and create users with the same form. 