# Assignment

Given a map, you'll probably want to read data from it.
There are many ways to proceed:

```elixir
map = %{a: 1, b: 2, c: 3}

# Map.get/2 returns nil if key is not part of map
value = Map.get(map, :a)    # value = 1
value = Map.get(map, :x)    # value = nil

# Map.get/3 returns default_if_missing in case of a missing key
value = Map.get(map, :b)       # value = 2
value = Map.get(map, :x, 0)    # value = 0

# Indexing operator returns nil for missing keys
value = map[:a]   # value = 1

# Indexing operator combined with ||
# Careful, there is a slight difference with Map.get/3!
# Cakepoint for first who tells us the difference
value = map[:x] || :oops   # value = :oops

# Destructuring
%{a => x} = map                   # x is now 1
%{a => x, b => y, c => z} = map   # x = 1, y = 2, z = 3
```

## Task

Write a function `Util.follow(map, start)` that works as follows:
say `map = %{:a => :b, :b => :c, :c => :d}` and `start = :a`:

* It looks up `:a` in `map`; this gives `:b`.
* Next, it looks up `:b` in `map`; this gives `:c`.
* Next, it looks up `:c` in `map`; this gives `:d`.
* Next, it looks up `:d` in `map`; the chain ends here.

The function should return the list of all encountered values: `[:a, :b, :c, :d]`.

Try to solve this three times:

* Using constructs you are familiar with.
* Using `Map.fetch` and `case`.
* Using `Map.fetch` and [Elixir's `with` expression](https://www.openmymind.net/Elixirs-With-Statement/).

You can write your solution in different files. Say you store your code in `student3.exs`, you
can run the tests using

```bash
$ STUDENT=student3.exs elixir tests.exs
```
