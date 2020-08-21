# Assignment

Remember `cond`? That construct that replaces `if`-chains in Elixir?
It looked like this:

```elixir
cond do
  condition1 -> ...
  condition2 -> ...
  condition3 -> ...
end
```

Turns out you can also use it to pattern match!

```elixir
cond x do
  pattern1 -> ...
  pattern2 -> ...
  pattern3 -> ...
end
```

For example,

```elixir
# Full house == pair and triple
def full_house?(cards) do
    cond sort_cards_by_value(x) do
        {x, x, x, y, y} -> true
        {y, y, x, x, x} -> true
        _               -> false
    end
end
```

In fact, you can even throw in some guards, too:

```elixir
# For purists that don't consider 5 5 5 5 5 a real full house
def full_house?(cards) do
    cond sort_cards_by_value(x) do
        {x, x, x, y, y} when x != y -> true
        {y, y, x, x, x} when x != y -> true
        _                           -> false
    end
end
```

## Task

We revisit the mathematical expressions from a previous exercise,
to which we make one addition: variables.
We represent variables by atoms. For example, the variable x
is simply represented by `:x`.

Variables can appear wherever a number can appear in an expression.
For example, `{:+, :x, 1}` is a valid expression.
We can add as many variables we want: `{:+, :x, {:*, :y, :z}}`.

Write a function `Math.simplify(expression)` that
simplifies an expression. An example of such
a simplification: `{:+, :x, 0}` simplifies to `:x`.
Take a look at the tests to find out
which simplification rules we expect you to implement.

We suggest a stepwise approach:
the tests are grouped in steps to allow you to focus on one group at the time.
