# Assignment

## Task

Write a function `Util.filter(xs, predicate)` where

* `xs` is a list of items
* `predicate` is a function that given a single parameter, returns `true` or `false`.

`filter(xs, predicate)` should return a list of items of `xs` for which `predicate` returns `true`.
These items must appear in the same order as they do in `xs`.

For example,

```elixir
filter([1,2,3,4,5], &Integer.is_odd/1)
```

should return `[1, 3, 5]`.
