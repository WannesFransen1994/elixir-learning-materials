# What is mix

While you can understand GenServers, Supervisors, Tasks, etc... and how they work, it is important that you can make an application out of it. You won't only be using your code, but also other people their code (dependencies) and so on.

Quoting the description from the docs, Mix is a build tool that provides tasks for creating, compiling, and testing Elixir projects, managing its dependencies, and more. Let us look at some things that Mix does for us.

Create a new project with `mix new example_project`.

## Folder structure

You'll see the following created file and folders:

* `README.md`
* `.formatter.exs`
* `.gitignore`
* `mix.exs`
* `lib`
* `lib/example_project.ex`
* `test`
* `test/test_helper.exs`
* `test/example_project_test.exs`

The `README.md` and `.gitignore` are files that are used with Git. It is extremely common to (privately) put your packages on Git(Hub/ Lab) and these files are recommended. When you use these services, those files are practically a must. Though these are default files. For example, the `.gitignore` is quite basic and you'll want to add some extra files/folders to be ignored. Take a look at [gitignore.io](gitignore.io) and put "Elixir" and "VisualStudioCode" (change this by your IDE) in the box.

_Note for those that aren't familiar with Git, it is common to initialize the root of the git folder at this level. __Don't__ make an extra folder and put the generated code there. Your generated `.git` folder after executing `git init` should be at the same level as the generated `README.md`!_

The `lib` folder will contain `.ex` (files that will be compiled) files. You'll create your code here. A sample module is already created. The `test` folder contains a helper for your tests and a sample test.

The `mix.exs` file will contain most of the project configuration. Here you'll configure your dependencies, what your project is called, what applications need to be started, and so on. Let us add a simple dependency.

## Dependencies

You can configure your dependencies in your `mix.exs` file with the private `deps/0` function. This function returns a list of dependencies that are required for this project.

```elixir
  defp deps do
    [
      {:tesla, "~> 1.3"}
    ]
  end
```

Installed dependencies are downloaded in the `deps` folder. After retrieving your dependencies with `deps.get`, you'll see that the dependency is downloaded and a `mix.lock` file appears. This lock file is a file in which the exact version of a dependency is described. This guarantees repeatable builds and should be committed into your git repository as well.

## Common commands

You can view a lot of common commands with `mix help`. The commands that you'll need the most will probably be:

```bash
mix test
mix compile
mix clean
mix deps.get
iex -S mix run
```

That last command will probably need some explanation. Imagine that you're making an application (with or without alive processes). If you'd like to manually test things, simply running `mix run` will end immediately after compiling your modules. Iex comes to the rescue, after executing `iex -S mix run` you can test your newly compiled modules in an iex session.

_Just an extra, but no need to restart your shell all the time. Just execute `recompile` while you're in your iex session! Processes aren't restarted!_

## Going for an OTP application

While a project with modules is often enough, you'll most likely build applications on top of that with processes that are "alive". Let us generate a very simple project with an application supervisor. Generate your project with `mix new example_project --sup`. You'll see that in your `mix.exs` file the following is added:

```elixir
def application do
  [
    # ... not important
    mod: {ExampleProject.Application, []} # This line was added!
  ]
end
```

Here we can see that when we run our application, the `ExampleProject.Application` module called upon. This module needs to enforce the `Application` behaviour. Let us take a look at that module:

```elixir
defmodule ExampleProject.Application do
  use Application

  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: ExampleProject.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

We won't go into details into the application lifecycle, as we want to keep this chapter concise, but know that when you start your application the children in the list will be started just like a normal supervisor. Verify this with `iex -S mix run` and then starting your observer (applications tab) with `:observer.start`. Now you should see your application supervisor!

Now you can start making applications. Go make some exercises!

## Extra materials

* [Configuring your project \[TODO\]](configuring-your-project.md)