# Process links and monitors

_For this chapter you will need to know the basics of processes, pids, messages, pattern matching and other elixir fundamentals._

## Introduction

As you already have seen, you can easily spawn a process with:

```elixir
iex> spawn fn -> IO.puts "hi" end
```

As you know already, the shell itself is a process as well with a PID. You can see this with:

```elixir
iex> inspect self
```

You can also let a process raise an error with the `raise` function. Another option would be to brutally kill it with `Process.exit/2`. Let us see what happens with our caller process when we do this:

```elixir
iex> inspect self
"#PID<0.136.0>"
iex> Process.exit self, :kill
** (EXIT from #PID<0.136.0>) shell process exited with reason: killed

iex> inspect self
"#PID<0.139.0>"
```

As you undoubtedly have already surmised, after killing your own process a new one is started. But the interesting part is the `EXIT` message. In order to understand it, we will have to explain the difference between normal and trapping exit processes, which will be illustrated with links.

## Links

The unofficial motto "Let it crash!" is there for a reason. In comparison with other programming languages where you have to program defensively, we don't want that overhead. Though one big question is... what to do when it crashes? How can we monitor this? When process A and B are working on the same task and are communicating, it can happen that B crashes. In this case A has to crash as well. This can be done with a link.

### Links are bidirectional

```elixir
defmodule PingPong do
    # Note: this is the most rudimentary spawn! Check this with "inspect &(spawn)/3"
    # You normally never use this.
    def start(), do: spawn(__MODULE__, :loop, [])
    # The above lines spawns a process. It'll search for the function "loop" in the module,
    #  Which is PingPong (__MODULE__ gets replaced at compile time with the module it is written in)
    #  Last argument are the arguments. The amount of elements in this list determines the arity of the loop function.

    def loop() do
        receive do
            {:ping, from} ->
                IO.puts("ping")
                Process.send_after(from, {:pong, self()}, 1_000)

            {:pong, from} ->
                IO.puts("pong")
                Process.send_after(from, {:ping, self()}, 1_000)

            {:link, to} ->
                Process.link(to)
        end

        loop()
    end
end
```

When you execute the following lines of code, you'll see that the linked process died as well.

```elixir
# Create two ping pong processes
p1 = PingPong.start()
p2 = PingPong.start()

# Ask p1 to link itself to p2
send(p1, {:link, p2})

# Initiate the ping pong
send(p1, {:ping, p2})

# Kill p2
Process.exit(p2, :kill)

Process.alive?(p1)
Process.alive?(p2)
```

Note that links are bidirectional, meaning because we already linked `p1` to `p2`, there's no need to link `p2` to `p1`.

### Trapping exits

So we now know that a link alerts us when a process dies and most likely will have a specific result (such as other processes dying, or perhaps restarting them).

Instead of creating the links manually, this can also be accomplished with `spawn_link`. Let us link a random process with our iex shell.

```elixir
iex(1)> spawn_link(fn -> raise "uh oh" end)
** (EXIT from #PID<0.108.0>) shell process exited
```

As we can see, our iex shell crashes as well, which is what we want. What if you want to do something when this crash occurs? The crash (from the other process) actually sends a message to all linked processes. Though the iex shell process didn't get a message, it crashed as well. This is because when you make a process, it is by default a normal process. You can make it a trapping exit process with:

```elixir
iex(1)> Process.flag(:trap_exit, true)
```

`Process.flag` returns the old value, so don't be surprised when it returns `false`. Now spawn a linked process with a raise, and you'll see when you call `flush` that the exit message is in your mailbox.

```elixir
{:EXIT, #PID<0.119.0>,
{%RuntimeError{message: "uh oh"},
[{:erl_eval, :do_apply, 6, [file: 'erl_eval.erl', line: 678]}]}}
```

You can pattern match on this message, do something with it, restart the process, and so on. Supervisors rely on these messages to take corrective actions when they receive one.

## Monitors

Similar to links, we can receive the same exit messages with monitors. The difference is that when process A is monitoring B, A doesn't crash when B does.

### Monitors are unidirectional

As already mentioned, the calling process, or the monitoring process, does not crash when the monitored process does. Needless to say that this relation is unidirectional, while you can still take corrective actions based upon this message. _Actions can also be taken upon normal exits instead of crashes, as we'll illustrate in the next example._

```elixir
iex(1)> p = spawn(fn -> :timer.sleep(10_000) end)
#PID<0.132.0>
iex(2)> Process.monitor(p)
#Reference<0.1590173300.1898971143.218430>
iex(3)> flush()
{:DOWN, Reference<0.1590173300.1898971143.218430>, :process, #PID<0.132.0>, :noproc}
```

Take note of the last message in the mailbox and also the response from `Process.monitor/1`! This is a reference, which acts as a sort of unique ID. Why is this not a PID? This is because not only processes can be monitored, but also nodes or ports. See [`:erlang.monitor/2`](http://erlang.org/doc/man/erlang.html#monitor-2) for more information.

As for the message in the mailbox, this is no longer an exit message but a down message. Depending on this, you can take different actions.
