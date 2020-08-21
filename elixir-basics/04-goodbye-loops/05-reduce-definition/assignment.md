# Assignment

Time to define `reduce`. This one is more challenging:
it is rather abstract, but that is what makes it quite powerful.
Most other "loop functions" can be implemented in terms
of `reduce`, but not the other way around.
While understanding `reduce` is not critical,
it can be quite helpful in many circumstances.

`reduce` gets its name from the fact that
it takes a list and reduces it to a single value
(which, ironically, might be another list,
but that is often not the case).
Think of SQL's aggregation functions, such as
`sum`, `avg`, `count`, `min`, `max`, ...
All these functions take a list and reduce
it to a single value.

There are multiple ways of looking at reduce.
The simplest way (but least flexible) is
to think of `reduce` as "injecting" a binary operator
in between all items of a list.
For example, consider `sum`. You have
a list of numbers

```text
1   2   3   4   5
```

To take the sum of these numbers, we add `+` operators in between the values:

```text
1 + 2 + 3 + 4 + 5
```

And there you go, we got our sum! But what happens if we have the empty list?
To deal with this case, we add an extra element in front of the list;
in case of `sum`, this would be `0`:

```text
0   1   2   3   4   5

^
added in front
```

Now, regardless of how many items our list contains, the result will always
be a sensible value. Expressing this operation in terms of `reduce` gives

```elixir
# &+/2 refers to the binary + operator
reduce([1, 2, 3, 4, 5], 0, &+/2)
```

A more general way of interpreting `reduce` is as a stepwise accumulator.
Let's take `sum` again as our working example.

* We start off with `0`. Let's call this `acc`, from accumulator.
* We combine the first element (`1`) with this `0` using the given binary function, here `+`. This gives `acc + 1 = 0 + 1 = 1`. This becomes `acc`'s new value.
* We combine the second element (`2`) with this latest value. This gives `acc + 2 = 3`. Again, this becomes `acc`'s new value.
* Combining the third element gives `acc + 3 = 6`.
* Combining the fourth element gives `acc + 4 = 10`.
* Combining the fifth element gives `acc + 5 = 15`.

## Task

Define `Util.reduce(xs, init, f)` where

* `xs` is a list of elements.
* `init` is the initial value for `acc` with which you'll start combining values.
* `f` is a binary function.
  * Its first argument will be an element of `xs`.
  * Its second argument will be the latest version of `acc`.

`reduce` should take every element `x` of `xs` in turn, combine it with `acc` using `f`, and use this result as the new value for `acc`.
When all items have been processed, `acc` should be returned as final result.
