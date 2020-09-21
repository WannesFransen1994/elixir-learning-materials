# Configuring your project

There was a lot of code generated when running the `mix new` command. Though the configuration settings of the project were missing.

## Basic setup

First of all, let us create a very simple process which prints a certain config value every X seconds.

```elixir
defmodule ConfigDemo.ConfigPrinter do
  use GenServer

  def start_link(args \\ []), do: GenServer.start_link(__MODULE__, args)

  def init(_) do
    :timer.send_interval(2000, :print_some_config)
    {:ok, :not_important_state}
  end

  def handle_info(:print_some_config, _state) do
    IO.puts("Loaded endpoint: " <> Application.fetch_env!(:config_demo, :api_endpoint))
    {:noreply, :not_important_state}
  end
end
```

We can see that every 2 seconds the `:api_endpoint` key for the `:config_demo` application will be printed out. Our next step is to configure this. Make the folder `config` and in that folder create the `config.exs` file with following contents:

```elixir
import Config

config :config_demo,
  api_endpoint: "www.ucll.be"
```

Here we can see that we `config` (imported function!) our `:config_demo` application. We can add configuration in the form of a keyword list. This config is loaded every time we compile our application. __This is not runtime configuration!__

_If you want runtime config, check how you can use `config/release.exs` in the docs._

Now start your application by defining the genserver in your application supervisor. 

```elixir
defmodule ConfigDemo.Application do
  use Application

  def start(_type, _args) do
    children = [
      ConfigDemo.ConfigPrinter
    ]
```

Now when you start up your application, you can see that it'll print the `:api_endpoint` every 2 seconds!

## Environment-specific config

When we import the `Config` functions with `import Config`, we can use functions such as `import_config/1` which can be useful when we want environment-specific configuration. This can be achieved with

```elixir
import_config "#{Mix.env()}.exs"
```

This will load configuration files such as `dev.exs` or `prod.exs`. When using a database for example, you don't want to develop using your production database. Though there's no need to do this right now. Let us focus on the basics.

## Wrong configurations

In the above basic config, we've configured our `:config_demo` application. When we configure an application that's not available, errors will appear. Let's try this out:

```elixir
import Config

config :random,
  api_endpoint: "wwww.ucll.be"
```

Will give the following error:

```text
You have configured application :random in your configuration file,
but the application is not available.

This usually means one of:
# ...
```

When you see this error, it is best to fix it. Don't copy-paste mindlessly!

This should be enough to get you started. Good luck!