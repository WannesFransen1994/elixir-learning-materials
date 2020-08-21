# Assignment

Let's take a closer look at parameter passing.
In Java, things are quite straightforward:
if a method requires 3 parameters,
you need to give it 3 values.

```java
// Java
void foo(int x, int y, int z) { }

foo(1, 2, 3);
```

Java 1.5 dared add something frivolous: varargs.
This allows you to define methods that take
a variable number of arguments:

```java
// Java
void foo(int x, int y, int z, int... rest) { }

foo(1, 2, 3, 4, 5, 6);
// int x = 1
// int y = 2
// int z = 3
// int[] rest = { 4, 5, 6 }
```

C# goes a bit further and allows you to pass
arguments out of order, on condition that
you explicitly mention which parameter gets
assigned what value. You can also define default values for missing
parameters.

```csharp
// C#
void Foo(int x, int y, int z = 5, params int[] rest) { }

Foo(y: 2, x: 3);
// int x = 3
// int y = 2
// int z = 5
// int[] rest = {  }
```

Python goes even further:

```python
# Python
def foo(x=0, y=0, z=0, *args, **kwargs): pass

foo(1, 2, 3, 4, 5, a=5, b=6)
# x = 1
# y = 2
# z = 3
# args = [4, 5]
# kwargs = { 'a': 5, 'b': 6 }
```

In other words, `*args` is an array that receives the leftover positional arguments and
`*kwargs` is a `dict` that gets the remaining `keyword=value` pairs.

Basically, the parameter list of a function can be viewed
as describing a pattern. When calling the function,
the given arguments are matched to this pattern and assigned to the correct variables.

Like Python, Elixir supports advanced "parameter patterns", but they work
quite differently from Python's. For now, we'll limit ourselves
to the absolute basics, but we'll revisit them when we reach data structures,
which is where the pattern matching mechanism really shines.

## Matching Literal Values

Let's start with a "boring" definition of `sign`. Remember that `sign` should
return `1` for a positive `x`, `-1` for a negative `x` and `0` if `x` equals zero.
We get

```elixir
# Elixir
def sign(x) do
    cond do
        x > 0  -> 1
        x < 0  -> -1
        x == 0 -> 0
    end
end
```

Let's rewrite this using multiple clauses and guards:

```elixir
# Elixir
def sign(x) when x > 0 , do: 1
def sign(x) when x < 0 , do: -1
def sign(x) when x == 0, do: 0
```

We now go one step further:

```elixir
# Elixir
def sign(x) when x > 0 , do: 1
def sign(x) when x < 0 , do: -1
def sign(0), do: 0
```

Elixir allows you to mention specific values in the parameter list.
This causes the clause to only be considered whenever the corresponding
argument is equal to that value.

A more extreme example is

```elixir
# Elixir
def foo(0, 0, 0), do: "a"
def foo(1, 2, 3), do: "b"
def foo(x, y, z), do: "c"
```

* Calling `foo(0, 0, 0)` matches the first clause and the result will be `"a"`.
* Calling `foo(1, 2, 3)` matches the second clause and the result will be `"b"`.
* Calling `foo(9, 9, 9)` falls through to the third, "catch all" clause. The result is `"c"`.

## Task

Define `Fibonacci.fib(n)` that computes the `n`th number of Fibonacci.
The Fibonacci series is defined as follows:

* `fib(0)` is equal to `0`.
* `fib(1)` is equal to `1`.
* All subsequent numbers are equal to the sum of their 2 predecessors. E.g. `fib(2)` equals `fib(0) + fib(1)`
  and `fib(1000)` equals `fib(998) + fib(999)`.

You might want to rely on recursion for this exercise.
