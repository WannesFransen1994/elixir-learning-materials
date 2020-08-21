# Assignment

Define a function `Exercise.flatten(xs)` that, given
a list that might contain arbitrarily deeply nested other lists,
returns a flattened version.

## Example

```elixir
iex(1)> flatten([1])
[1]

iex(2)> flatten([[1]])
[1]

iex(3)> flatten([1, [2], 3, [[[[4]]]]])
[1, 2, 3, 4]
```
