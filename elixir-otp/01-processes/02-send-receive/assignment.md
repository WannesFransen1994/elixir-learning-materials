# Assignment

Processes need to be able to communicate somehow,
otherwise creating new processes would
be a rather futile endeavor as they
would be doomed to remain isolated in separate "universes".

Communication between processes is done through message passing.
Each process has its own *process id*, often abbreviated as pid.
The pid of a newly spawned processes is returned by `spawn`:

```elixir
pid = spawn(&func/0)
```

A process can send an arbitrary message (a string, a number, a tuple, ...)
to another processes as follows:

```elixir
send(pid, message)
```

This puts a message in `pid`'s mailbox.
It is important to know that `send` returns immediately:
there is no waiting for the other process to
process the message. The current process
will proceed immediately with executing the rest of its code.

Now, if we can send messages, we also ought to be able to
receive messages. How does `pid` check its mailbox?

```elixir
receive do
  message -> # Do something with message
end
```

Here, `message` is a variable that is bound to the value
sent by `send`. For example, if we had written
`send(pid, "hello")`, then `message` would be equal to `"hello"`.

`receive` is *blocking*: if no message is available in the
process's mailbox, it will wait until a message arrives.

When `send`ing and `receive`-ing messages, (generally) two processes are involved,
meaning you have no idea in what order the `send` and `receive` are executed.
Luckily, thanks to how they work, it does not matter:

* If process A `send`s a message before process B is ready to `receive`,
  the message will be stored in the mailbox in the meantime.
* If process B tries to receive a message that has not been sent yet,
  it will simply wait for a `send` to happen.

Whatever the order, the result will be the same.

## Task

As an exercise, we create a process that,
when we send it a message, will print this message to the console.

* Start with defining a nullary function `print`.
  Its sole task is to `receive` a message and immediately print it.
* Next, spawn a process with `print` as its starting point.
  Be sure to store the pid `spawn` returns in a variable.
  Using this pid, `send` a string to the `print` process.
* Remember to put a `:timer.sleep(1000)` at the end.
