# Assignment

Time to make a full fledged application with processes. The context of this exercise is a server which has multiple instances (of e.g. a map). Since too many players in a single instance will cause problems such as lag, too many players in hunting areas, and so on..., we'll make server instances dynamically.

## Task 1 - the `GameServer` its interface

First create a `ExerciseSolution.GameServer` process that will keep track of the instances. Sample usage with `iex -S mix run` _(add --werl after iex if you're on windows)_ would be:

```elixir
iex> ExerciseSolution.GameServer.add_instance InstanceA
:ok
iex> ExerciseSolution.GameServer.add_instance InstanceB
:ok
iex> ExerciseSolution.GameServer.add_instance InstanceC
:ok
iex> ExerciseSolution.GameServer.list_instances
%{InstanceA => nil, InstanceB => nil,InstanceC => nil}
```

The GameServer is a GenServer. When you start up the application, this GenServer should be started automatically and be name registered under its module name.

Verify that the server is started with `:observer.start` _(applications -> your project name)_, after which you can execute the above code.

## Task 2 - the dynamic supervisor

Right now we're only modifying our state in our GenServer. Let us go a step further and provide a DynamicSupervisor for our genserver to start children under.

Make a module-based `DynamicSupervisor` that's called `InstanceSupervisor`. When executing `InstanceSupervisor.start_link/1`, the process should be name registered under its module name. Start the supervisor when the application starts.

__Think about the order in which the `GameServer` and `InstanceSupervisor` should be started!__

<details>
<summary>Answer:</summary>
First start the `DynamicSupervisor` and after that the `GameServer`. This is because later on clients will ask our `GameServer` to log on to an instance. This means that `GameServer` depends on the supervisor. Not the other way around, as the `DynamicSupervisor` doesn't need to interact with the `GameServer` at all.
</details>

Verify this with `:observer` or:

```elixir
iex> Process.whereis ExerciseSolution.InstanceSupervisor
#PID<0.159.0>
```

## Task 3 - Adding a simple instance

Time to define what our instances can do. Create the `GameInstance` module (which is a GenServer). You should be able to add players to the instance and retrieve all the players.

Also provide an interface to the `InstanceSupervisor` to easily add an instance. You need to provide the name of the instance. You'll pass this as a keyword list. Sample usage would be:

```elixir
iex> ExerciseSolution.InstanceSupervisor.add_instance(name: InstanceA)
{:ok, #PID<0.167.0>}
iex> ExerciseSolution.InstanceSupervisor.add_instance(name: InstanceA)
{:error, {:already_started, #PID<0.167.0>}}
iex> ExerciseSolution.InstanceSupervisor.add_instance([])
{:error, :no_name_param}
iex> ExerciseSolution.InstanceSupervisor.add_instance(name: InstanceB)
{:ok, #PID<0.174.0>}
```

Verify that your processes are started with `:observer.start`. You should see processes started under the `InstanceSupervisor`.

## Task 4 - managing your instances

We're not going to add our instances manually to our `GameServer` and adding those instances. This should be done all at once.

```elixir
iex> ExerciseSolution.GameServer.add_instance InstanceA
:ok
iex> Process.whereis InstanceA
#PID<0.167.0>
iex> ExerciseSolution.GameServer.list_instances
%{InstanceA => nil}
```

Now we can see that our `GameInstance` process is created and it is put in the state at the same time. It is up to you to use `GenServer.call/2` or `GenServer.cast/2` to add instances. You could (with `call`) return an error to the caller immediately, or opt for an error logging approach (with `cast`).

In case of the error logging approach, you can expect something like:

```elixir
iex> ExerciseSolution.GameServer.add_instance InstanceA
:ok
iex> ExerciseSolution.GameServer.add_instance InstanceA
:ok
iex>
12:02:18.103 [warn]  Could not create instance because of {:already_started, #PID<0.246.0>}
```
