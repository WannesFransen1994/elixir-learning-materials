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

<details><summary>Answer:</summary>
<p>

First start the `DynamicSupervisor` and after that the `GameServer`. This is because later on clients will ask our `GameServer` to log on to an instance. This means that `GameServer` depends on the supervisor. Not the other way around, as the `DynamicSupervisor` doesn't need to interact with the `GameServer` at all.

</p>
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

## Task 5 - Connecting / assigning players

While we have our instances and manager process started, they aren't doing a lot. Time to assign fictive players to instances. Since a player would be represented as another process (one with a TCP connection for example), we need to provide a PID as well.

First of all, instances keep track of __which__ players are connected to their instance. So how do we assign a player to a `GameInstance`? In ideal situations it'd be based on some kind of smart algorithm. Though right now (as the `GameServer` doesn't know how many players are connected to each instance) we will just use the random strategy. Randomly assign a player to an instance.

```elixir
iex> ExerciseSolution.GameServer.add_instance InstanceA
:ok
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell", self()
{:connected_to_instance, #PID<0.160.0>}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell", self()
{:error, :already_connected_client, #PID<0.158.0>, :to_instance, #PID<0.160.0>}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell2", self()
{:connected_to_instance, #PID<0.160.0>}
iex> ExerciseSolution.GameServer.add_instance InstanceB
:ok
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell4", self()
{:connected_to_instance, #PID<0.185.0>}
```

_Verify whether the players are kept in the state of the instance with `:observer`. Go to a process in the supervision tree, double click / right click -> info, state section._

Based on the example code, you can see that the `GameServer.assign_player_to_instance/2` function is a `GenServer.call`. This is only normal as the player needs to receive information as to whom it should connect to. Beware though, keep in mind that calls are blocking. In this case the `GameServer` will receive a message and need to perform a `call` to the instance as well. _(Also check whether the player is already in our instance! This might happen during a random disconnect/reconnect.)_

_Later on we will fix this the above call by replying late. Imagine a launch of a game, you don't want your "assign player to an instance" operation to be purely synchronous. Why is that? `GameInstances` are very busy! Meaning that you might have to wait a bit until the message is processed. If the caller, in this case `GameServer`, needs to wait for that busy instance, that means that all other players that are trying to connect in an instance have to wait as well! We don't want that, so replying late is the solution. That's for later though, but keep it in mind._

## Task 6 - Reporting how busy instances are

Until now we've just used a random strategy. This is not really practical of course. Let us provide enough information to our `GameServer` to use a more realistic approach to divide users. _We should assume after all that users can switch instances (and thus let new players connect to lowly populated instances to balance the load)._

The instances should report every 10 seconds to the `GameServer` how many players are present. This communication can start from 2 points:

* Starting from the `GameServer`. Perform a `call` to all instances every X seconds.
* Starting from the `GameInstance`. Perform a `cast` to the gameserver every X seconds.

Which one would you choose? The best approach, in this case, would be to let our `GameInstance` report with a simple `cast`. Why? As explained in the previous task, we don't want to wait on our instances. What happens if a `GameInstance` is very busy and our `GameServer` waits for it? No one could connect in the meantime! That's why a simple "report" message is good enough.

_Keep in mind though, you should always assume `cast` messages can be lost in the process. Is that a problem in this case? Not really. It doesn't matter that much whether data is 10 seconds old, or it is 15 seconds old._

Enough chit-chat. Let us implement it and execute some sample code:

```elixir
iex> ExerciseSolution.GameServer.add_instance InstanceA
:ok
iex> ExerciseSolution.GameServer.list_instances
%{InstanceA => %{pid: #PID<0.160.0>, players: 0}}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell", self()
{:connected_to_instance, #PID<0.160.0>}
iex> :timer.sleep 10_000 # to illustrate that you should wait until the state is updated
:ok
iex> ExerciseSolution.GameServer.list_instances
%{InstanceA => %{pid: #PID<0.160.0>, players: 1}}
iex> ExerciseSolution.GameServer.add_instance InstanceB
:ok
iex> ExerciseSolution.GameServer.list_instances
%{
  InstanceA => %{pid: #PID<0.160.0>, players: 1},
  InstanceB => %{pid: #PID<0.168.0>, players: 0}
}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell2", self()
{:connected_to_instance, #PID<0.160.0>}
# got connected to instance A... that's the downside of random strategy
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell3", self()
{:connected_to_instance, #PID<0.168.0>}
# Yes! Connected to instance B.
iex> ExerciseSolution.GameServer.list_instances
%{
  InstanceA => %{pid: #PID<0.160.0>, players: 2},
  InstanceB => %{pid: #PID<0.168.0>, players: 1}
}
```

While there are still some kinks that should be ironed out, we now have a very simple game server. Well, at least the instance managing part at least.

## Task 7 - algorithm based on N players in instance

TODO: Implement algorithm that assigns a player based on an algorithm that divides a percentage of the new players to an instance.

It's up to you to implement an algorithm that you think is useful, but we'll provide a naive WRR (Weight Round Robin) like algorithm.

```text
Imagine you have Instance A, B and C.
The following connections are registered:
  A: 15
  B: 25
  C: 60
This means that there are 100 current connections. We calculate an indication as to how we want to distribute the upcoming connections.
TOTAL = 100
  Atemp = Total / A => 5.333 ...
  Btemp = Total / B => 3.2
  Ctemp = Total / C => 1.333 ...
  Totaltemp = SUM(Atemp, Btemp, Ctemp) => 9.866667

Based on these temporary values, we can calculate the % chance that the connection will be assigned to each instance.
  Achance = ROUND(Atemp/Totaltemp, 2) => 0.54 => 54% chance to be assigned to A
  Bchance = ROUND(Btemp/Totaltemp, 2) => 0.32 => 32% chance to be assigned to B
  Cchance = ROUND(Ctemp/Totaltemp, 2) => 0.14 => 14% chance to be assigned to C

While this might not be totally correct... it is just to give you an indication. It is not our aim to create a mathematically correct load balancing algorithm.
```

## Task 8 - monitor the instances

TODO: Instances can crash, this will cause our `GameServer` to crash as well. This shouldn't happen as, ideally speaking, the PID registered in our `GameServer` should be updated as well.

## Task 9 - register when started

TODO: when an instance is started, it should register itself instead of relying on the output of the dynamic supervisor. This also makes the code more flexible when an instance is restarted by the supervisor. We'll basically be programming our own `Registry`.

## Task 10 - replying late when assigning a player

TODO: reply late so that assigns are not blocking.

## Summary

The above suggested solutions are not best practices. This is meant to give you an introduction into OTP applications and certain situations where monitoring and registering on start could be useful. A lot of the above could be optimized with e.g. a Registry implementation. Other topics, such as distribution, haven't been covered as well.

Solution code, just like this assignment, is meant for educational purposes.
