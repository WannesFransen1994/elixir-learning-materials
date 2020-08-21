# Task

Similar to the last exercise of the previous week, use libcluster with the gossip strategy to easily detect other nodes.

Make an application that creates "matches" for ping pong games. We're not going to focus on OTP best practices, but just make a simple application like so:

```text
App.Supervisor
       \
        | --> DynamicGameSupervisor --> ping and pong processes.
         \
          \ --> GameManager
```

Your GameManager is a naive implementation that holds a state with games and their associated ping/pong processes.

```elixir
%{
    game1: [ping: PID, pong: PID],
    game2: [ping: PID, pong: PID],
    ...
}
```

These PID's are all supervised by your `DynamicGameSupervisor`. Don't worry about crashes for now, that's not important for this exercise.

The goal is to have 2 "gameserver" nodes that each hold a similar amount of matches. It doesn't matter whether you add games all the time on node A or node B, they'll get distributed evenly. You can achieve this by retrieving the # of matches on each node and start the match on the node with the least # of matches.

You should easily be able to horizontally scale your application.

_Hint: You can register your genserver when starting it with start_link like so:_

```elixir
GenServer.start_link(__MODULE__, :ok, name: {:via, :global, {Node.self(), __MODULE__}})
```
