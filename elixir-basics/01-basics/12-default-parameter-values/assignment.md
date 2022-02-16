# Assignment

Many languages have support for default parameter values:

```csharp
// C#
void Foo(int x = 5) { }

Foo(); // x implicitly set to 5
```

While this might not be a crucial feature of Elixir,
you'll very probably come across it when
perusing the documentation. Added to that, its unfamiliar syntax
might be a bit confusing.

The syntax for default parameters is as follows:

```elixir
# Elixir
def foo(x \\ 5) do
    ...
end
```

## Task

Define a function `Math.range_sum(to, from, step)` that computes
the sum of the numbers from, from + step, from + 2 &times step + ... + to.
For example, `range_sum(5, 0, 1)` must equal `1 + 2 + 3 + 4 + 5 = 15`,
and `range_sum(5, 0, 2)` must equal `0 + 2 + 4 = 6`.

* If omitted, `from` should be set to `0`.
* If omitted, `step` should be set to `1`.

Do not rely on multiple clauses for this exercise.
