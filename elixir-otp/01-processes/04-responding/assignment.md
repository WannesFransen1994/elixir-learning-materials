# Assignment

Until now, we have been adding a `:timer.sleep(1000)` call at the end of our scripts.
This was necessary due to the fact that when the "main process" ends, all other processes
are forcibly ended. For example:

```elixir
defmodule Exercise do
    def foo() do
        # Random time consuming stuff
        drainage!()
        drinks_milkshake()
        throws_bowling_balls_around()

        IO.puts("I'm finished!")
    end
end

spawn( &Exercise.foo/0 )
```

The main process spawns the `foo` child process. After this, there is nothing left to do,
so it ends. However, Elixir interprets this as the end of your application,
even though `foo` is still busy.
We solved this issue in previous exercises by adding a `sleep` instruction.
However, this is a very fragile solution: how long should we `sleep` for in this case?
There is no way of knowing.

While it is possible to sleep for an infinite amount of time, it'd be better
if the child process somehow lets the parent process know it's done with its task.
This can be accomplished using the same `send`/`receive` mechanism
we use to send messages to the child process.

For a process A to send a message to a process B, it needs
to know its pid. In our case, the parent process knows
the child's process's pid because `spawn` returns it.
But how would the child process get access to the parent process's pid?

One way would be to pass it along when the child process is created:

```elixir
defmodule Exercise do
    def foo(parent_pid) do
        # Random stuff that takes a while
        drainage!()
        drinks_milkshake()
        throws_bowling_balls_around()

        IO.puts("I'm finished!")
    end
end

parent_pid = self()
spawn( fn -> Exercise.foo(parent_pid) end)
```

As you may have guessed, the `self()` function returns the calling process's pid.
Now that `foo` receives the parent pid as parameter, it is able to send messages
back to the parent process.

## Task

We build on the `print` exercise.

* Pass the parent pid to `print` as shown above.
* Have `print` send a message to back to its parent. This message can be anything you want.
* `print` ends with a recursive call to itself. Think about how this should be updated.
* Have the parent process send N messages to the child process, where you can pick any N you want.
* After having sent N messages to the child process, the parent process
  should have N responses in its own mailbox. Have the parent process perform N `receive`s
  successively. These `receive`s can simply ignore the messages. If you need to express "do nothing"
  in Elixir, writing `nil` will do admirably.
