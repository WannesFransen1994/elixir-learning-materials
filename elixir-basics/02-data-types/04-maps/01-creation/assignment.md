# Assignment

As good as every language offers at least two types of containers:

* Sequence containers
  * C#: `List<T>`, `T[]`
  * Java: `ArrayList<T>`, `T[]`
  * Python: `list`
  * JavaScript: arrays
* Associative containers
  * C#: `Dictionary<K, V>`
  * Java: `HashMap<K, V>`
  * Python: `dict`
  * JavaScript: objects

Sequence containers are data structures in which you can store values and
arrange them in a sequence. The container will keep track of each value's position.
For this category of containers, Elixir provides tuples and linked lists.

Associative containers are data structures that associate values with keys.
In Elixir, the built-in associative containers are called `Map`.
Map literals take the form `%{key1 => val1, key2 => val2, ...}`.

Given you are already familiar with map-like data structures,
there is not a lot to tell. The main difference is that Elixir's maps
cannot be modified, so that's something you'll have to keep in mind
when interacting with them.

We refer you to on the [online documentation](https://hexdocs.pm/elixir/Map.html)
for further information.

## Task

Write a function `Util.frequencies(xs)` that, given a list `xs`,
creates a map containing the frequencies of each element of `xs`.

For example, say `xs = [:a, :b, :b, :c, :c, :c]`,
then `frequencies(xs)` should return `%{:a => 1, :b => 2, :c => 3}`.

Note that when keys are atoms, there's an alternative syntax for map literals:

```elixir
%{ a: 1, b: 2, c: 3 }
```

Don't be confused by the fact that there are two different notations.
