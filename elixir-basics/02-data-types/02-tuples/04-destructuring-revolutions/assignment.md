# Assignment

## Task

We can represent mathematical expressions using trees built out of tuples.

Let's start simple. The expression 5 (yes, just the number) is easy to model:
we simply use `5` to represent 5,

We can also represent addition. Addition is a binary operator, i.e.,
it has two operands, a left one and a right one. We can
represent 1 + 2 using the tuple  `{:+, 1, 2}`. Note how we use
the atom `:+` to denote addition.

We can nest these additions: (1 + 2) + (3 + 4) is represented by

```elixir
{:+, {:+, 1, 2},
     {:+, 3, 4}}
```

We can do the same for other operators, such as `-`, `*` and `/`:

```elixir
# 4 - 1
{:-, 4, 1}

# 3 * 5
{:*, 3, 5}

# 6 / 2
{:/, 6, 2}
```

These can be arbitrarily nested:

```elixir
# (1 + 5) * (4 - 1)
# -----------------
#      (7 + 2)

{:/, {:*, {:+, 1, 5},
          {:-, 4, 1} },
     {:+, 7, 2} }
```

Write a function `Math.evaluate(tree)` that computes the value of the expression.
For example,

```elixir
iex(1)> Math.evaluate({:+, 2, 3})
5

iex(2)> Math.evaluate({:*, 2, 3})
6
```
