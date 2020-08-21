# Assignment

The following couple of exercises revolve around a new concept, namely *guards*.
There are multiple facets to them, which we'll focus on each in turn.

Let's revisit an old exercise, say `sign`.
`sign` only makes sense on numeric values.
Say you implemented it as follows:

```elixir
defmodule Numbers do
  def sign(n) do
    cond do
      n > 0 -> 1
      n < 0 -> -1
      true  -> 0
    end
  end
end
```

It seems okay, but what if we were to call `sign` on a string value?

```elixir
Numbers.sign("oh no")
```

Elixir doesn't check types, so it merrily executes
the function's body and tries to compare `"oh no"` with `0`.
This is a rather risky affair:

* Python would strenuously object: it can't handle comparing strings to numbers and throws an error in your face.
* JavaScript, always trying to be accommodating, will convert the string to a number and pretend nothing happened.

Elixir chooses to tread a different path: there's actually an order defined
on all data types: all numbers have been determined to be less than booleans, and all booleans (both of them!)
are less than all strings. You can even compare functions to lists if you wish (for the curious ones: functions are smaller than lists).

This order is completely arbitrary and you should *definitely* neither know it nor rely on it.
Code whose correct behavior depends on this weird order is very fragile: it most
likely works by accident.

Anyway, we have our answer: `sign("oh no")` returns `1`, since strings are greater than numbers according to Elixir.
But is there perhaps a way to avoid such random results?

The problem would not exist in a statically typed language such as C#, Java or C++: they would
simply prohibit you from even performing the call. We can do something similar in dynamically typed languages:
we add a runtime check that ensures the argument is numeric. In Python this would look like

```python
# Python
def sign(n):
    if type(n) != int:
        raise TypeError()
    else:
       ...
```

While a similar approach is possible in Elixir, there is a more idiomatic way than to rely on conditionals: guards.

```elixir
# Elixir
def sign(n) when is_number(n) do
    cond do
      n > 0 -> 1
      n < 0 -> -1
      true  -> 0
    end
end
```

Do not confuse guards with a static type system! `sign("oh no")` will not be rejected at compile time;
instead, it will lead to a runtime error.

For each built-in type, there is a corresponding function that checks whether a value has that type.
You can find a list [here](https://hexdocs.pm/elixir/Kernel.html). Note how, although
these functions are predicates, they lack the characterizing question mark at the end of their name.
This is to make them stand out: the `is_` prefix indicates the predicate is meant to be used in guards,
while "regular" predicates are not allowed there.

Multiple checks can be combined using the `and` operator:

```elixir
def foo(a, b) when is_number(a) and is_string(b) do
    ...
end
```

## Task

Define `Numbers.odd?` and `Numbers.even?`. Have them rely on guards to filter out invalid parameter types.
