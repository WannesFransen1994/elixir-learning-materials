# Assignment

In the previous exercise, you were advised
to define separate functions `standard`, `bronze`, `silver` and `gold`.
While there is nothing wrong with defining separate functions,
sometimes it's a bit of a burden, especially when
the functions in question are very short.

An alternative would be to define the four functions inline, as lambdas.
A lambda is a function which you don't bother to give a name to.
For this reason, they're also called *anonymous functions* (which is the term
Elixir uses, so if you need to look up something online, use "anonymous functions").
For example, the code

```elixir
def foo(x) do
    x
end

def get_foo() do
    &foo/1
end
```

can be rewritten as

```elixir
def get_foo() do
    fn x -> x end
end
```

Here, `fn x -> x end` is the lambda. The arrow `->` separates parameters from body.
In case you want to define lambdas with multiple clauses, you can [look up the syntax online](https://lmgtfy.com/?q=elixir+anonymous+function+multiple+clauses),
but perhaps it might be better to rely on named functions in this case for readability. However, in a later exercise,
we'll see how lambdas have a distinct advantage over regular functions.

For the lazy, Elixir also supports an even shorter syntax:

```elixir
def get_foo() do
    &(&1)
```

Here, `&(...)` introduces a function. The parentheses enclose the function's body. The parameters are not given names;
instead, they are referred to by their ordinal: `&1` for the first parameter, `&2` for the second, etc.
It should speak for itself that this syntax should only be used for the simplest of functions.
Concise is good, cryptic is bad.

## Task

Solve the previous exercise (`Shop.discount`) again, but make use of lambdas instead of named functions.
