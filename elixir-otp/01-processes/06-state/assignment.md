# Assignment

The `magic_eight_ball` process from the previous exercise
is a lot like a function: given an argument,
it returns a value. It is also deterministic:
it will give the same output each time it is given the same input.
The process is *stateless*.

That shouldn't be too surprising: after all, Elixir
is a purely function language, which means that
everything is stateless. Or is it?

A weird phenomenon arises when dealing with
processes and their nondeterministic scheduling:
it can reintroduce state. We could philosophize
about this for pages, but due to budget restrictions,
we have to keep it short.

So, let's create a simple counter, the Elixir equivalent
of the following C# code:

```csharp
public class Counter
{
    private int current;

    public Counter(int initial)
    {
        this.current = initial;
    }

    public int Next()
    {
        return this.current++;
    }
}
```

In Elixir, usage should look like this:

```elixir
parent_pid = self()
counter_pid = spawn( fn -> Counter.counter(parent_pid) end)

# Ask for next number by sending it a dummy message
send(counter_pid, nil)

# Receive the answer
receive do
  n -> IO.puts(n) # Should print 0
end

# Rinse and repeat
send(counter_pid, nil)
receive do
  n -> IO.puts(n) # Should print 1
end

send(counter_pid, nil)
receive do
  n -> IO.puts(n) # Should print 2
end
```

Our challenge is to define `Counter.counter` so that the above code
exhibits the behavior specified in the comments. Somehow,
the `counter` process has to keep a variable that it increments each time,
but... isn't that impossible in Elixir?

Let's write a first draft for this `counter` function by writing down those parts
we know for sure should be there. Afterwards, we'll twist and tweak it till it works.

```elixir
def counter(parent_id) do
  receive do
    _ -> send(parent_id, current) # need some variable "current"
  end

  counter(parent_id)
end
```

Think about how you would be able to introduce a variable `current` that is incremented
by one at each receive. Give it a couple of minutes.

## Task

Here's the solution to the above dilemma:

* Add an extra parameter `current` to `counter`. Set is default value to `0`.
* Have `counter`'s recursive call pass along `counter + 1`, so that the next iteration gets an incremented value.

Run the program to check that everything works as advertised.

Make sure you understand what happens here, as you will need it in the future:

* The counter's state is stored in its parameters.
* The state can be updated by having the function call itself with updated parameter values.
