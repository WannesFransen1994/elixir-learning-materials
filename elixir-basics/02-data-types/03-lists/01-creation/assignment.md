# Assignment

Start by reading the explanations on [linked lists](/docs/lists.md).

As explained in the text, a linked list is a series of pairs (also called nodes.)
It won't come as a surprise that to build a linked list, you
need to build it up one node at a time.

Elixir's syntax for linked lists is as follows:

* The empty list is written `[]`.
* A node is written `[ item | next ]`.

Thus, the list containing the values `1`, `2`, `3` is written

```elixir
list = [ 1 | [ 2 | [ 3 | [] ] ] ]
```

Fortunately, Elixir also provides some syntactic sugar
to allow you to write down lists in a more readable way.
The same list can be written

```elixir
list = [1, 2, 3, 4]
```

You can combine both. The following notations all denote the same list:

* `[1 | [2, 3, 4]]`
* `[1, 2 | [3, 4]]`
* `[1, 2, 3 | [4]]`
* `[1, 2, 3, 4 | []]`

In other words, you can see the `|` as a form of concatenation:
the items before it get joined with the list after the `|`.
In practice, you'll encounter the `[head | tail]` notation relatively often.
Make sure you understand its meaning:

* The list's first item is `head`.
* All other items are grouped in a smaller list named `tail`.

In the case of `[1, 2, 3, 4]`,
`head` equals `1` and `tail` equals `[2, 3, 4]`.

## Example

We shortly study a simple function `repeat(n, x)` that creates a list containing `n` occurrences of `x`.

```elixir
def repeat(0, x), do: []
def repeat(n, x), do: [x | repeat(n - 1, x)]
```

Make sure you take the time necessary to fully understand how this algorithm works.

* The base case is where `n == 0` is simple: 0 repetitions of anything is simple the empty list.
* Next comes the inductive case. In general, writing this case consists
  of finding a way to express `repeat(n, x)` in terms of `repeat(n - 1, x)`.
  In this example, the repetition of `n`&times;`x` is the equal
  to taking `(n-1)` &times; `x`, and adding an extra `x` to it.

## Task

Write a function `Util.range(a, b)` that returns the list `[a, a+1, ..., b]`.
