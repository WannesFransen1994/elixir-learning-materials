# Assignment

Let us create two processes and observe how they run concurrently.
We'll have them each print out a different message: the first
process prints out `foo` repeatedly, while the second outputs `bar`.

## Task 1

There are no tests for this exercise, so you'll have to check
your solutions manually.

First, write a function `repeat(n, f)` where

* `n` is a positive integer;
* `f` is a nullary function, i.e., a function that takes no arguments.

`repeat(n, f`) should call `f` `n`&times; in a row. In other words, `repeat(5, f)` should
do the same as

```elixir
f.()
f.()
f.()
f.()
f.()
```

The module name does not matter, choose one yourself.

## Task 2

Next, write `say_n_times(n, message)` that successively prints `message` `n` times.
Make use of `repeat` for this.

Make sure to check your work after this step; there is no point in continuing
without this part working as intended.

## Task 3

To spawn a new process, you can use the `spawn` function.

A new process needs code to execute. The standard way of giving
a piece of code to a function is by using functions:

```elixir
def func() do
    ...
end

spawn(&func/0)
```

The code shown above creates a new process that runs `func`.
After all code in `func` has been executed, the process ends.

You can of course also rely on lambdas:

```elixir
spawn( fn -> IO.puts("I pass the butter") end )
```

This creates a new process whose [only purpose in life](https://youtu.be/X7HmltUWXgs?t=53) is to print "I pass the butter."

Add code that spawns two processes:

* One process must print "foo" 10&times;.
* One process must print "bar" 10&times;.

When the "main process" ends, all other processes go down with it. To counteract this,
add `:timer.sleep(1000)` at the end of the script to make sure the two spawned processes get sufficient time
to do their thing.

Run the code multiple times. You should be able to observe a change in the order in which `foo` and `bar` get printed.
This is due that no guarantees are given as to when each process gets to run.
