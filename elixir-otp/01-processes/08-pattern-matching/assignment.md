# Assignment

Our `counter` process behaves more and more like an object:
it has state and it has a "method" that returns the next value.
It only has one method though, which is a bit restrictive.
Perhaps we should add more.

Our intention is to translate the following counter to Elixir:

```csharp
class Counter
{
    private int current;

    public Counter()
    {
        this.current = 0;
    }

    public int Inc()
    {
        return ++this.current;
    }

    public int Dec()
    {
        return --this.current;
    }
}
```

Since object methods correspond to messages, we need to
find a way to send different messages.
It turns out that `receive` actually supports multiple clauses
as well as pattern matching. For example,

```elixir
receive do
  x when is_number -> IO.puts("a")
  :some_atom       -> IO.puts("b")
  [x, y]           -> IO.puts("c")
  {:atom, data}    -> IO.puts("d")
end
```

`receive` will look for a message matching the given pattern in the mailbox. If it finds
one, the corresponding clause is executed. For example,

```elixir
send(pid, 5)              # prints "a"
send({ :atom, "hello" })  # prints "d"
send([1, 2, 3])           # No match, will remain in mailbox until another receive accepts this pattern
```

## Task

Extend the `counter` exercise as follows:

* Implement the equivalent of `Inc`: the corresponding message has the form `{:inc, sender_pid}`.
* Implement the equivalent of `Dec`: the corresponding message has the form `{:dec, sender_pid}`.

Verify your work by sending a couple of messages and checking the responses.
