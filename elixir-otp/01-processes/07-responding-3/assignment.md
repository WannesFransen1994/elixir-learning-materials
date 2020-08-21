# Assignment

Our `counter` process from the previous exercise is given its parent process's pid
at creation:

```elixir
defmodule Counter do
  def counter(parent_pid, current \\ 0) do
    ...
  end
end

parent_pid = self()
pid = spawn( fn -> Counter.counter(parent_pid) end )
```

Let's give each process a name for clarity's sake:

* Process `Main` is he "main process", the one who spawns the `counter` process.
* Process `Counter` is the  child process that runs `counter`.

Right now, `Counter` always sends its responses to `Main`.
That might be problematic, say we create extra processes `A`, `B` and `C`,
each of which also send messages to `Counter`. They won't get any responses,
as they all arrive in `Main`'s message box. This does make little sense.

We would like that `Counter` sends its answer to the process that sent it
a message. If `A` asked for the next counter value, `A` should receive it, not `Main`.

Fortunately, this is easy to fix: instead of passing `Main`'s process id when creating the `Counter` process,
we pass it along the message:

```elixir
def counter(current \\ 0) do
  receive do
    sender_pid -> send(sender_pid, ...)
  end
end
```

## Task

Update your code as follows:

* Remove the `parent_pid` parameter from `counter`. Update the spawning code and the recursive call.
* Update the `receive` construct so that it receives the sender's pid. `send` should send the `current` value back to this sender.
