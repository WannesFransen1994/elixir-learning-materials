# Assignment

Wonderful. You can now let processes crash together. Now monitor those processes and log crashes to the screen.

The exit message from a crash differs from a normal exit message. Feel free to execute following code to see what it entails.

```elixir
testfunc = fn ->
  :timer.sleep 5000
  :ok
end
pid = spawn testfunc
Process.monitor pid
:timer.sleep 5000
flush
```

__The solution is different from last exercise!__
