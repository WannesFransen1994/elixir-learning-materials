# Assignment

When discussing tuples, we mentioned destructuring:

```elixir
{first, second, third} = tuple
```

The same technique is available on lists:

```elixir
xs = [ 1, 2, 3, 4, 5 ]

[ head | tail ] = xs
# head == 1
# tail == [2, 3, 4, 5]

[ first, second | rest ] = xs
# first = 1
# second = 2
# rest = [3, 4, 5]
```

## Task

Write the following functions in a module named `Util`:

* `first(xs)` returns the first element of the list `xs`.
* `second(xs)` returns the second element of the list `xs`.
* `third(xs)` returns the third element of the list `xs`.
* `last(xs)` returns the last element of the list `xs`.
* `size(xs)` returns the size of the list `xs`.

Each of these functions can assume that the list
does contain the necessary number of elements.

Note: some of these functions are readily available to
you in Elixir's standard library, possibly under a different name.
For this exercise, you are of course not supposed
to make use of them.
