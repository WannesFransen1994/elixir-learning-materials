# Assignment

## Task

Usage of the `counter` process is a bit cumbersome.
Hide all `counter`-related functionality
behind function calls and make internal details invisible from outside the module using `defp`.

This is the old usage code:

```elixir
pid = spawn(&Counter.counter/0)

send(pid, :inc)
send(pid, :inc)
send(pid, :inc)

send(pid, {:get, self()})
receive do
  answer -> IO.puts(answer)
end

send(pid, :dec)

send(pid, {:get, self()})
receive do
  answer -> IO.puts(answer)
end

send(pid, :reset)

send(pid, {:get, self()})
receive do
  answer -> IO.puts(answer)
end
```

Write the necessary functions so that the above can be rewritten as

```elixir
counter = Counter.start()

Counter.inc(counter)
Counter.inc(counter)
Counter.inc(counter)
IO.puts(Counter.get(counter))

Counter.dec(counter)
IO.puts(Counter.get(counter))

Counter.reset(counter)
IO.puts(Counter.get(counter))
```
