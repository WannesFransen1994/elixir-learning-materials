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

Right now we're assigning players randomly over our instances. In a game context, users can log out, which means that the "random" algorithm won't be the best choice. If you provide the option that users can change instances themselves, this problem might even become worse over time. This task will let you implement another strategy to assign new connections.

The proposed algorithm assigns a player based on a weighted percentage. This percentage is calculated based on the current connected players to an instance. It is not necessary to do this perfectly, as we don't have real-time feed from our instances (regarding connected players). This would only cause a lot of messages that don't have a lot of added value anyway.

Question to you: why do you think least first isn't a good choice as an algorithm?

<details><summary>Answer:</summary>
<p>

* We don't have a realtime feed, causing to "overload" an instance every 10 seconds
* Traffic, and thus also workload, isn't distributed evenly. Once instance is handling a lot of new players at once
* This will result in another instance handling new connections roughly every 10 seconds. Thus mitigating the problem up until a certain point where there are similar-loaded instances. This isn't the case when a new instance shows up, as it will be the least connected server for longer than 10 seconds. This extremely loaded instance will thus be very busy, causing a delay to new players that want to log in.

</p>
</details>

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

You can test the above with following code (I've added some extra IO.inspect to show the above calculations):

```elixir
iex> ExerciseSolution.GameServer.list_instances
%{}
iex> ExerciseSolution.GameServer.add_instance InstanceA
:ok
iex> ExerciseSolution.GameServer.add_instance InstanceB
:ok
iex> ExerciseSolution.GameServer.list_instances
# When adding an instance, I quickly give a very high percentage to make sure
#   it is selected first.
%{
  InstanceA => %{percentage: 100, pid: #PID<0.148.0>, players: 0},
  InstanceB => %{percentage: 100, pid: #PID<0.151.0>, players: 0}
}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell1", self()
# Here you can see that this results in a number between the sum of the below numbers.
#   Normally this is a number between 1-100%, but instances that don't have any players
#     will score very high.
Elixir.DATA: [{InstanceA, 10000}, {InstanceB, 10000}]
Elixir.RANDOM_NUMBER: 2939
Elixir.RESULT_INSTANCE: InstanceA
{:connected_to_instance, #PID<0.148.0>}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell2", self()
# Note: Despite Instance A already having a connected player, the percentagage is extremely high.
#  This is because the new players are connected within the 10 second window (and the GameServer isn't updated yet)
Elixir.DATA: [{InstanceA, 10000}, {InstanceB, 10000}]
Elixir.RANDOM_NUMBER: 9449
Elixir.RESULT_INSTANCE: InstanceA
{:connected_to_instance, #PID<0.148.0>}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell3", self()
Elixir.DATA: [{InstanceA, 1.0}, {InstanceB, 99.0}]
Elixir.RANDOM_NUMBER: 12
Elixir.RESULT_INSTANCE: InstanceB
{:connected_to_instance, #PID<0.151.0>}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell4", self()
# Here you can see that the instances have reported back after they have some connections.
Elixir.DATA: [{InstanceA, 33.0}, {InstanceB, 67.0}]
Elixir.RANDOM_NUMBER: 65
Elixir.RESULT_INSTANCE: InstanceB
{:connected_to_instance, #PID<0.151.0>}
iex> ExerciseSolution.GameServer.list_instances
%{
  InstanceA => %{percentage: 0.5, pid: #PID<0.148.0>, players: 2},
  InstanceB => %{percentage: 0.5, pid: #PID<0.151.0>, players: 2}
}
```

Just a quick note regarding selecting an instance based multiple percentages. In the solution I've used the following approach:

```text
(sorted from low to high)
Instance percentages: A: 5%, B: 35%, C: 60%
Random number between 1-100 ->
Examples:
  e.g. 20
  20 is higher than 5, subtract 5 from 20 and go to the next element.
  15 is lower than 35 -> choose instance B

  e.g. 45
  45 is higher than 5, subtract 5 from 45 and go to the next element.
  40 is higher than 35, subtract 35 from 40 and go to the next element.
  5 is lower than 60 -> choose instance C
```

There is most likely a better solution, but this is just a suggestion.

## Task 8 - monitor instances & register when started

Now that we've got a very basic implemetation, we can happily say that it works. Well, at least when there are no crashes. We all know that instances crash for various reasons... Let us see how our current implementation handles this.

First create some instances and add some players.

```elixir
iex> ExerciseSolution.GameServer.add_instance InstanceA
:ok
iex> ExerciseSolution.GameServer.add_instance InstanceB
:ok
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell1", self()
{:connected_to_instance, #PID<0.148.0>}
iex> ExerciseSolution.GameServer.assign_player_to_instance "iex_shell2", self()
{:connected_to_instance, #PID<0.151.0>}
```

Next, open your `:observer` with `:observer.start` and kill all the started instances. In my case, my `GameServer` crashes because of `no match of right hand side value: nil`. This is because when the report comes in, it'll search for the instance based on the PID. While we could program our way around this (if pid not in state ... do ...), we'll let our 'GameServer' crash. Bluntly stating that it needs this information (the instance associated with the PID) to be able to work.

### SubTask 8A. Monitoring instances

So how do we resolve this problem? Well this will need 2 steps. First, we'll monitor our instances so that they are deleted from the state when something crashes. When this happens (and the messages arrives at our `GameServer`), we'll just delete that instance from our state. Let's not think about instances that aren't working and just focus on the good ones.

_If you finish this task you can still receive errors when testing it manually. When a report message arrives, it'll still try to associate the PID with an instance. Don't worry, this doesn't have to work for now. Test manually that the instance is removed within the report window with `list_instances`._

## SubTask 8B. instance registration

Now we'll make it a bit more durable so that our `GameServer` doesn't crash all the time. When an instance starts, it'll have to register itself at the `GameServer`. This way, when an instance is (re)started, the `GameServer` has its updated PID.

Verify this by doing te above steps again, though only this time the `GameServer` shouldn't crash and its state (instances with their associated PID's) should be updated automatically. When you execute `ExerciseSolution.GameServer.list_instances/0`, you should see updated PID's.

```elixir
iex> ExerciseSolution.GameServer.add_instance IA
:ok
iex> ExerciseSolution.GameServer.add_instance IB
:ok
iex> ExerciseSolution.GameServer.list_instances
%{
  IA => %{percentage: 100, pid: #PID<0.162.0>, players: 0},
  IB => %{percentage: 100, pid: #PID<0.164.0>, players: 0}
}
iex> :observer.start
:ok
iex> # kill instance A in observer
iex> ExerciseSolution.GameServer.list_instances
%{
  IA => %{percentage: 100, pid: #PID<0.192.0>, players: 0},
  IB => %{percentage: 100, pid: #PID<0.164.0>, players: 0}
}
iex> # kill instance B in observer
iex> ExerciseSolution.GameServer.list_instances
%{
  IA => %{percentage: 100, pid: #PID<0.192.0>, players: 0},
  IB => %{percentage: 100, pid: #PID<0.201.0>, players: 0}
}
```

_Note: we're basically mixing a very basic `Registry` within our logic of our `GameServer`. This is thus not good design of our OTP application! We'll cover `Registry` later. This is a good exercise to understand why you need a `Registry` and how it kind of works (this is a naive implementation after all)._

## Task 9 - replying late when assigning a player

Right now we're adding players one by one. Another problem might be that the calculation to decide upon the instance might be a little costly (depending on your implementation). The more time it requires to complete, the longer it'll take when a lot of players connect at the same time. This is something that we don't want, so we'll assign these players asynchronously.

### Subtask 9A. Add a task supervisor

In order to reply late, we'll want to do asynchronous calculations. This means that we'll have extra processes! Extra processes means a bigger supervision tree. What approach can we take in order to design this in a robust way?

* Link them directly to the `GameServer` (which starts up the tasks)
* Start them under a `Task.Supervisor` (thus being unlinked to the `GameServer`, but is linked & supervised by the supervisor)
* Unsupervised, unlinked processes _(we won't even consider this option. Similar to a self-driving car which isn't supervised at all)_

<details><summary>Answer:</summary>
<p>

We'll start them under a separate supervisor. There is always a chance that processes crash, so in order to make oure process robust we'll want to isolate these errors.

In order to organise our code, it is also useful to provide a seperate module where this logic is located. You'll pass the necessary data (instance information & message information) to the newly spawned process and do the calculation there.

For now, create a Task Supervisor and verify it is running with `:observer.start`.

</p>
</details>

### Subtask 9B. Asynchronously calculating the next instance

Now that we've got the supervisor, do the following things:

* Start the Task from the `GameServer`. Make sure the `GameServer` process is not linked to the Task!
* Keep track of the tasks in the state of your `GameServer`
* Pass the necessary information to the newly spawned Task
* Make sure that the "calculate instance" logic is in the separate Task module
* While the client may do a `GenServer.call`, don't reply immediately
* Provide a clause to process the response from the Task
* Adjust your current clause for monitored processes that go down. Check whether they're down messages that come from either:
  * your instance that crashes
  * your task that replies
  * messages that aren't from both of these, may be ignored. Do log a warning though.

There's still some other details that should be taken care of (what if a Task fails? What should we do then?), but for now you can be happy with the current solution.

Here we see that if the `Registry` logic would no longer be in our `GameServer`, our code base should become a lot cleaner. Feel free to try this yourself!

## Summary

The above suggested solutions are not best practices. This is meant to give you an introduction into OTP applications and certain situations where monitoring and registering on start could be useful. A lot of the above could be optimized with e.g. a Registry implementation. Other topics, such as distribution, haven't been covered as well.

Solution code, just like this assignment, is meant for educational purposes.
