# Overview

Internationalization is an import aspect of your application. Not to mention that it is very tricky, as [some companies](https://www.translatemedia.com/translation-blog/coca-cola-cancels-french-campaign-due-to-translation-blunder/) have already experienced. This is often called I18n, where the 18 stands for the letters in the word. Do not confuse this with localization, which also means that you're adjusting your website for the end user his/her culture (date formatting, currency, ...).

We're going to create a simple website with 2 pages containing some text. After that we'll implement internationalization so that we can support different languages. As a finishing touch, we'll store the language preference in a cookie.

## Setting up the website

Create a new project with:

```bash
 mix phx.new i18n --no-ecto --no-webpack --umbrella --no-dashboard
```

_**Make this a umbrella project in order to get a deeper understanding how Phoenix uses gettext! You'll also acquire important insights regarding circular dependencies and how these can be resolved.**_

Adjust the following files, an in-depth explanation should no longer be necessary of the following changes:

```elixir
# i18n_web/router.ex
  scope "/", I18nWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/another_index", PageController, :another_index
  end
```

```elixir
defmodule I18nWeb.PageController do
  use I18nWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def another_index(conn, _params) do
    render(conn, "another_index.html")
  end
end
```

```html
<!-- templates/layout/app.html.eex -->
      <nav role="navigation">
        <ul>
          <li>
            <a href="/">HOME</a>
          </li>
          <li>
            <a href="/another_index">ANOTHER INDEX</a>
          </li>
        </ul>
      </nav>
```

```html
<!-- templates/page/index.html.eex -->
<p>Welcome to the world of Elixir and Phoenix!</p>
```

```html
<!-- templates/page/another_index.html.eex -->
<p>Students from UCLL are so great!
    They can make a website with Phoenix in English and Japanese!</p>
```

When you fire up your web app, you'll see a simple website with two links. That is what we're going to internationalize.
