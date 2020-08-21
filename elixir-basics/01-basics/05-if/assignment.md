# Assignment

Time to introduce conditionals. Perhaps this is a good time to
explain the difference between *expressions* and *statements*.

Languages such as C++, C#, Java, Python and JavaScript
make the distinction between expressions and statements:
an expression evaluates to a value, whereas statements don't.
For example,

```csharp
# C#
Console.WriteLine(5 + 3)
```

Here, `5 + 3` is an expression built out of the smaller expressions `5` and `3`.
When evaluated, `5 + 3` yields `8`. Because of this, you can pass `5 + 3` as an argument to `WriteLine`:
the expression will be evaluated and its result is what `WriteLine` will receive.

Conversely, a statement does not evaluate to a value. You could compare
it to a "void-expression". For example, take the `if` statement in C#;
the following code is invalid:

```csharp
# C#
Console.WriteLine(if ( x == y ) 5; else 10;)
```

You could imagine that if `x` were equal to `y`, `5` would be printed, but as mentioned
above, this is simply not valid syntax. The same rule applies to Python, Java, etc.

Ironically, their designers realized that having an `if`-*expression* could come in handy,
so they introduced it using a separate syntax:

```csharp
// C#
Console.WriteLine(x == y ? 5 : 10);
```

```python
print(5 if x == y else 10)
```

Another example of statements are loops: it simply makes no sense
to have a loop evaluate to a value. What would it mean to "print a loop"?

Elixir's `if`s are, contrary to the languages mentioned earlier, expressions.
The following code is therefore valid:

```elixir
IO.puts(if x == y do
          5
        else
          10
        end)
```

As you might expected, it prints `5` or `10` depending on whether `x` equals `y`.

An important consequence is how `if` are to be used in conjunction with functions.
Consider the C# code

```csharp
// C#
int Foo()
{
    if ( condition )
    {
        return a;
    }
    else
    {
        return b;
    }
}
```

Translating this to Elixir might look problematic due to the language having no `return`.
However, since `if`s are expressions and since functions automatically
return the value of their last expression, we can write

```elixir
# Elixir
def foo() do
    if condition do
        a
    else
        b
    end
end
```

## Task

Write the function `Numbers.abs(x)` that computes the absolute value of `x`.

Note how we provided two solutions. Make sure to examine them both.
