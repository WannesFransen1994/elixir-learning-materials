# Assignment

Right now, it might seem guards are a poor man's replacement for type checking,
but a longer syntax and slower execution don't make them particularly appealing.
In reality, guards are much more general than this.

As of yet, you are used to having functions having one single body:

```python
# Python
def foo(x):
    # Everything goes here
```

If different values of `x` needs different treatment, you
fork execution inside the function's body:

```python
# Python
def foo(x):
    if x > 0:
        # Deal with positive x
    else:
        # Deal with nonpositive x
```

This approach is perfectly acceptable in Elixir, but the language also offers an alternative.

```elixir
# Elixir
def foo(x) when is_number(x) and x > 0, do: # Deal with positive x
def foo(x) when is_number(x), do: # Deal with nonpositive x
```

As you can see, Elixir allows you to split the definition
of a single function into multiple clauses, each
specialized in its very own part of the input.
When `foo` is called, the different clauses
are looked at in turn. As soon as a clause
is found whose guard evaluates to `true`, the search for
a matching clause ends and its corresponding body is evaluated.
If no such clause is found, an error ensues.

## Task

Write `Numbers.abs`. Make use of multiple clauses and guards to distinguish between inputs,
i.e., no `if`s or `cond`s allowed.
