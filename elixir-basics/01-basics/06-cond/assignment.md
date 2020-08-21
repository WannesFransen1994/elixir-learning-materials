# Assignment

An `if` expression is great for dealing with two distinct cases:
one in which the condition is true, one in which it isn't.
Sometimes there are more than two cases, which
traditionally we can deal with by chaining `if`s together:

```python
# Python
if cond1:
    ...
elif cond2:
    ...
elif cond3:
    ...
else:
    ...
```

Elixir would rather have you use a slightly different construct, namely
the `cond`. It looks as follows:

```elixir
# Elixir
cond do
    cond1 -> ...
    cond2 -> ...
    cond3 -> ...
    true  -> ...
end
```

The `cond` will look for the first condition that evaluates to true
and evaluate the corresponding clause. There is no `else`
but you can easily fake it by using `true` as last condition.

Like `if`, `cond` is an expression.

## Task

Write the function `Numbers.sign(x)` that returns

* `1` if `x` is strictly greater than `0`.
* `0` if `x` equals `0`.
* `-1` if `x` is less than `0`.

Make sure to rely on `cond` to solve this exercise.
