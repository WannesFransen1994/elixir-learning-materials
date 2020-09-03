# Assignment

## Task

Rewrite the function `Util.count(xs, predicate)`, this time by making use of `reduce`.

Hints:

* How many elements satisfy `predicate` in an empty list? That's your initial `acc`.
* Contrary to `size`, this time, the elements' values are relevant since they determine whether they have to be counted or not. The combiner will therefore take the form `fn x, acc -> ... end`.
* `combinator(x, acc)` means "Here's `acc`, the number of items I've already found that satisfied `predicate`. Here's another element, `x`. Please update `acc` for me."
  In other words, `combinator(x, acc)` should return `acc + 1` if `x` satisfies `predicate`, or return `acc` if it does not.

## Examples

```elixir
iex> xs = [:atom, "string", :another_atom, "another_string"]
iex> Util.count(xs, &is_atom/1)
2
```
