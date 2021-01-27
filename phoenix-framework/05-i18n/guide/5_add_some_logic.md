# Adding an interface to the logic

## `router.ex`

First add the route, we'll just work with a simple request url attribute. The link will look like [http://localhost:4000/perform_some_logic?max=50](http://localhost:4000/perform_some_logic?max=50)

In order to add the route:

```elixir
# router.ex
    get "/perform_some_logic", PageController, :perform_some_logic
```

## Add the controller function

In your `PageController` module add the following action:

```elixir
  def perform_some_logic(conn, %{"max" => max}) do
    IO.inspect(params)
    render(conn, "another_index.html")
  end
```

Add the following to your `layout/app.html.eex`:

```html
        <ul>
          <li><a href="/">HOME</a></li>
          <li><a href="/another_index">ANOTHER INDEX</a></li>
          <!-- this part below -->
          <li><a href="/perform_some_logic">PERFORM SOME LOGIC</a></li>
        </ul>
```

Make a super simple generated password dump template (call it `page/password_display.html.eex`):

```html
<p>
    <%= @password %>
</p>
```

And at last the controller logic:

```elixir
  def perform_some_logic(conn, %{"max" => max}) do
    {max_parsed, _} = Integer.parse(max)

    case I18n.random_string(max_parsed) do
      {:ok, password} ->
        render(conn, "password_display.html", password: password)

      {:error, message} ->
        conn |> put_flash(:error, message) |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def perform_some_logic(conn, _params) do
    redirect(conn, to: Routes.page_path(conn, :perform_some_logic, max: 50))
  end
```

Now click on the link on your homepage and you should see a generated password. In you URL bar, put in a high number (e.g. 500), and you should see the translated error message.
