# Assignment

## Task

Define a function `Util.count(xs, predicate)` where

* `xs` is a list of items
* `predicate` is a function that given a single parameter, returns `true` or `false`.

`count`'s job is to count the number of items for which `predicate` returns `true`.

For example,

```elixir
count([1,2,3,4,5], &Integer.is_odd/1)
```

should count the number of odd numbers in `[1, 2, 3, 4, 5]` and hence should return `3`.
