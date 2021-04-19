# Translations in an umbrella application

While it's all works up until now, we'll notice some difficulties as soon as we want to translate domain error messages. Well, actually messages of any kind. This is because we'll introduce circular dependencies. We'll go into details as to how the circular dependency issue arises, and how we'll solve it.

At the time of writing, there is still no general approach as to solve this issue. We will work with a single translation module as suggested on [this github issue](https://github.com/elixir-gettext/gettext/issues/126#issuecomment-255518564). _It is of course possible to create a gettext module for every project in your umbrella app._

## Adding some domain logic

One of the use cases you'll commonly stumble upon is the need to translate error messages of your domain model. Because we're working with a sample app without a database, we will emulate this by creating a password generator.

This extremely simple password generator will accept a length parameter. If the length is too long, it'll raise an error.

Include the following code in the `I18n` file located in the `i18n` project. (Not in `i18n_web`)

```elixir
defmodule I18n do
  @default_size 64
  @max_size 255
  def random_string(size \\ @default_size)

  def random_string(size) when not is_integer(size),
    do: {:error, "The provided size isn't a number. No can do."}

  def random_string(size) when size > @max_size,
    do: {:error, "The provided size is too large. The largest size we support is #{@max_size}"}

  def random_string(size) when is_integer(size) do
    response =
      :crypto.strong_rand_bytes(@default_size) |> Base.url_encode64() |> binary_part(0, size)

    {:ok, response}
  end
end
```

If we'd want to translate a domain error message here, we could try the following:

```elixir
defmodule I18n do
  require I18nWeb.Gettext
  @default_size 64
  @max_size 255

  @error_message_no_int "The provided size isn't a number. No can do."
  @error_message_too_large "The provided size is too large. The largest size we support is %{max_size}"

  def random_string(size \\ @default_size)

  def random_string(size) when not is_integer(size),
    do: {:error, I18nWeb.Gettext.gettext(@error_message_no_int)}

  def random_string(size) when size > @max_size,
    do: {:error, I18nWeb.Gettext.gettext(@error_message_too_large, max_size: @max_size)}

  def random_string(size) when is_integer(size) do
    response =
      :crypto.strong_rand_bytes(@default_size) |> Base.url_encode64() |> binary_part(0, size)

    {:ok, response}
  end
end
```

If you'd try to compile this (run the server), you'd see the following (remove your `_build` folder!):

```text
== Compilation error in file lib/i18n.ex ==
** (CompileError) lib/i18n.ex:2: module I18nWeb.Gettext is not loaded and could not be found
```

This is because you're depending on a module that isn't compiled yet. That's why you have to add it to your dependencies in `mix.exs`. Only thing is, it'll not work because you've introduced a circular dependency!

```elixir
# updated - faulty - mix.exs file in the i18n project:
  defp deps do
    [
      {:phoenix_pubsub, "~> 2.0"},
      {:i18n_web, in_umbrella: true}
    ]
  end
```

Output when you try to compile now:

```bash
$ mix compile
** (Mix) Could not sort dependencies. There are cycles in the dependency graph
```

So, we have 2 possible solutions right now. Create a gettext module for each project, or centralise our translations in one app. We'll go for the latter

## Extracting the dependencies in a new project

First of all, go to the `apps` folder and generate a new project. After that, create a `priv/gettext` folder.

```bash
$ mix new i18n_translations 
...
Your Mix project was created successfully.
...

$ cd i18n_translations && mkdir -p priv/gettext

```

Add the `gettext` dependency to your project (`i18n_translations`) dependencies in your `mix.exs` file.

```elixir
  defp deps do
    [{:gettext, "~> 0.11"}]
  end
```

Create a `Gettext` module that will have the necessare code injected functions.

```elixir
defmodule I18nTranslations.Gettext do
  @moduledoc """
  ...
  """
  use Gettext, otp_app: :i18n_translations
end
```

Add the gettext compiler action to your project compile actions:

```elixir
# mix.exs
  def project do
    [
      app: :i18n_translations,
      #...
      # Add this line
      compilers: [:gettext] ++ Mix.compilers(),
      # ...
    ]
  end
```

### Cleanup of your `i18n_web` project

#### mix.exs file

Delete the following parts of your `mix.exs` file:

```elixir
  def project do
    [
      app: :i18n_web,
      # ...
      # Delete the :gettext part

      # OLD:
      # compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      
      # NEW:
      compilers: [:phoenix] ++ Mix.compilers(),
    ]
  end

  # ...

  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      
      # DELETE / COMMENT THIS LINE:
      # {:gettext, "~> 0.11"},
      {:i18n, in_umbrella: true},
      # Add another dependency
      {:i18n_translations, in_umbrella: true},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
```

Also delete the `gettext.ex` file that contains the `I18nWeb.Gettext` module. We no longer need it.

The next part is a bit more complex. Remember that you can use the `gettext/1` function in your templates without any problems? That's because of your `I18nWeb` module (filename `i18n_web.ex`). Open it, and adjust the following lines:

```elixir
defmodule I18nWeb do
  def controller do
   # ...
   # OLD
    # import I18nWeb.Gettext

   # NEW
      import I18nTranslations.Gettext
   # ...
  end

  # ...

  def channel do
   # ...
   # OLD
    # import I18nWeb.Gettext

   # NEW
      import I18nTranslations.Gettext
   # ...
  end

  defp view_helpers do
        # ...
        # OLD
        # import I18nWeb.Gettext

        # NEW
            import I18nTranslations.Gettext
        # ...
  end
end
```

_Now that we're in this file, try to figure out what happens when you use `use I18nWeb, :controller` in a controller module. Same goes for `use I18nWeb, :view` in a view module. Same thing for the `use I18nWeb, :router` in the router file._

_When you `use` a module, you'll call upon that module its `__using__` macro. This will `apply` (function that executes a function of a certain module) the function that's defined in the module. Don't worry about the `quote`, it just means that the code that's written within that `quote` block is injected in the module that "uses" the `I18nWeb` module._

#### Config

Update your config so that you configure your `i18n_translations` project

```elixir
# OLD
# config :i18n_web, I18nWeb.Gettext,

# NEW
config :i18n_translations, I18nTranslations.Gettext,
  locales: ~w(en ja),
  default_locale: "en"
```

#### Update your plug

just like with all the  rest, rename `I18Web.Gettext` to `I18nTranslations.Gettext`

```elixir
defmodule I18nWeb.Plugs.Locale do
  import Plug.Conn

  # @locales Gettext.known_locales(I18nWeb.Gettext)
  @locales Gettext.known_locales(I18nTranslations.Gettext)

  def init(default), do: default

  def call(conn, _options) do
    # ...
        # I18nWeb.Gettext |> Gettext.put_locale(locale)
        I18nTranslations.Gettext |> Gettext.put_locale(locale)
    # ...
end
```

#### Cleanup your priv folder

Remove your `priv/gettext` folder in your `i18n_web` project. It no longer belongs there.

_NOTE: copy paste the text somewhere if you've already added a lot of translations..._

### Cleanup of your `i18n` project

#### Actual logic in the `i18n.ex` file

This one is short and simple. Adjust your file that generates the random string:

```elixir
defmodule I18n do
  # require I18nWeb.Gettext
  require I18nTranslations.Gettext
  @default_size 64
  @max_size 255

  @error_message_no_int "The provided size isn't a number. No can do."
  @error_message_too_large "The provided size is too large. The largest size we support is %{max_size}"

  def random_string(size \\ @default_size)

  def random_string(size) when not is_integer(size),
    # do: {:error, I18nWeb.Gettext.gettext(@error_message_no_int)}
    do: {:error, I18nTranslations.Gettext.gettext(@error_message_no_int)}

  def random_string(size) when size > @max_size,
    # do: {:error, I18nWeb.Gettext.gettext(@error_message_too_large, max_size: @max_size)}
    do: {:error, I18nTranslations.Gettext.gettext(@error_message_too_large, max_size: @max_size)}

  def random_string(size) when is_integer(size) do
    response =
      :crypto.strong_rand_bytes(@default_size) |> Base.url_encode64() |> binary_part(0, size)

    {:ok, response}
  end
end
```

#### Your `mix.exs` file

Update your project dependencies so that it includes the `I18nTranslations` app.

```elixir
  defp deps do
    [
      {:i18n_translations, in_umbrella: true}
    ]
  end
```

## Generating the locales again

Now we have to pay attention. If you go into the `apps/i18n_translations` folder, you'll see that when you execute `mix gettext.extract --merge`, no translations are added.

Kind of obvious maybe, but in that project there is no usage of the `Gettext` module. That's why there are no translations. Now go into the root folder of your project and execute the following commands:

```bash
$ mix gettext.extract --merge
# .... compiling

$ ls apps/i18n_translations/priv/gettext
default.pot

$ cat apps/i18n_translations/priv/gettext/default.pot
# ...
msgid ""
msgstr ""

#, elixir-format
#: lib/i18n_web/templates/page/another_index.html.eex:2
msgid "Students from UCLL are so great! They can make a website with %{framework} in English and Japanese!"
msgstr ""

#, elixir-format
#: lib/i18n.ex:15
msgid "The provided size is too large. The largest size we support is %{max_size}"
msgstr ""

#, elixir-format
#: lib/i18n.ex:12
msgid "The provided size isn't a number. No can do."
msgstr ""

#, elixir-format
#: lib/i18n_web/templates/page/index.html.eex:2
msgid "Welcome to the world of %{language} and %{framework}!"
msgstr ""
```

Here we can see that the text has been found over the whole umbrella project. Don't forget to generate both the english and japanese locales with `mix gettext.merge absolute_path_to/priv/gettext --locale en` and `mix gettext.merge absolute_path_to/priv/gettext --locale ja`.

__It is important to use an absolute path.__ Since it's an umbrella project (with multiple projects in the `apps` directory), the task will be executed in different folders. When you use a relative path it'll look to the relative path starting from that folder, so it'll give strange errors and unexpected behaviour. Hence the absolute path.

You should see something like the following output:

```bash
$ mix gettext.extract --merge
==> i18n_translations
# ... compiling ...

$ mix gettext.merge /home/wannes/a_very_long_absolute_path/priv/gettext --locale en
==> i18n_translations
Created directory /home/wannes/.../priv/gettext/en/LC_MESSAGES
Wrote /home/wannes/.../priv/gettext/en/LC_MESSAGES/default.po (2 new translations, 0 removed, 0 unchanged, 0 reworded (fuzzy))
Wrote /home/wannes/.../priv/gettext/en/LC_MESSAGES/errors.po (2 new translations, 0 removed, 0 unchanged, 0 reworded (fuzzy))
==> i18n
Wrote /home/wannes/.../priv/gettext/en/LC_MESSAGES/default.po (0 new translations, 0 removed, 2 unchanged, 0 reworded (fuzzy))
Wrote /home/wannes/.../priv/gettext/en/LC_MESSAGES/errors.po (0 new translations, 0 removed, 2 unchanged, 0 reworded (fuzzy))
==> i18n_web
Wrote /home/wannes/.../priv/gettext/en/LC_MESSAGES/default.po (0 new translations, 0 removed, 2 unchanged, 0 reworded (fuzzy))
Wrote /home/wannes/.../priv/gettext/en/LC_MESSAGES/errors.po (0 new translations, 0 removed, 2 unchanged, 0 reworded (fuzzy))

$ mix gettext.merge /home/wannes/a_very_long_absolute_path/priv/gettext --locale ja
# ... similar output as before ...
```

_FYI: Don't forget to update your translations again!_

TODO: PROVIDE JAPANESE ERROR MESSAGE TRANSLATIONS

Next up is to add the functionality in our web app.
