# Compile-Time Checks

## Statically Typed Languages

Consider the following C# code:

```csharp
public class Foo
{
    public int Bar()
    {
        this.Bar(this.x);
    }

    public static void Main(string[] args)
    {
        Console.WriteLine("Hello world!");
    }
}
```

This code contains a number of mistakes:

* `Bar` fails to return an `int`.
* `this.x` does not exist.
* `Bar` is called with an argument, whereas it doesn't accept any.

These errors are known as *type errors* and will all be caught by the compiler, which will refuse
to translate your code as long as someone does not fix these mistakes.
Note that it does not even matter that the application does not make use of `Foo`:
*all* written code must obey the rules, regardless if it's used or not.

Languages that are checked in this way are known as *statically typed*.
Examples of such languages are C#, Java, C, C++, TypeScript, Rust, Go, F#, Scala, Swift, ...

## Dynamically Typed Languages

We translate the above code to Python:

```python
class Foo:
    def bar(self):
        self.bar(self.x)

print("Hello world!")
```

The same mistakes are present, but Python does not care: running
this code will happily print `Hello world!`. This is due to the following reasons:

* There is no static analysis phase that checks the code before running it.
* Execution does not reach the ill-written code.

In other words, Python does not perform any type checking ahead of time,
but it does so during program execution. This causes programs
to run more slowly. Another downside is that it's much harder
to detect errors: to ascertain there are no type errors left,
you need to run your application "in all possible ways" such
that every line of code is executed.

Languages that perform their type checking at runtime
are said to be *dynamically typed*. Examples of such languages
are Python, Ruby, JavaScript, ...

## Spectrum

The above explanation makes it seems that there are two clear categories
of computer languages: statically typed ones and dynamically typed ones.
In reality, it's more of a spectrum.

Consider the following C# code:

```csharp
int First(int[] xs)
{
    return xs[0];
}
```

The program can be considered well-typed:

* All mentioned types exist.
* The indexing operator is applied on an array, which is an object that supports that operation.
* The indexing operator is given an integer (`0`), which is the correct type for indices.

All these constraints are checked by the compiler, no surprises there.
However, there are still runtime checks:

* `xs` must not be `null`.
* `xs` must contain at least one element for `xs[0]` to work.

As of this writing, C#'s type system is not strong enough to check
both these conditions are valid during compilation. However,
future versions of C# should be able to detect whether `xs` is `null` or not.
The second constraint, however, will probably remain in the runtime world
for some time: very few languages are able to statically verify this. It requires
a *dependently typed* programming language, examples of which are [Idris](https://www.idris-lang.org/)
and [Agda](https://github.com/agda/agda).

In other words, a language can be characterized by which checks
it performs at compile-time and which it does at runtime:

* C# and Java use a combination of both.
* Python, Ruby, JavaScript only check at runtime.
* C and C++ check what they can at compile-time, but many constraints are left unchecked and result in undefined behavior at runtime.

## Elixir

So where does Elixir lie on this spectrum of statically and dynamically typed languages?
It's on a spot hitherto unknown to you, somewhere between C# and Python.

```elixir
def foo(x) when is_integer(x) do
  x * 2
end

foo(5)
foo("test")
foo()
```

The first call, `foo(5)`, is correct. The second call, however, passes a string to `foo`, while it clearly
states it expects an integer. Typically, statically typed languages would balk at this, but in Elixir's case,
will behave like Python: failure is postponed until runtime: the guard `when is_integer(x)`
is only checked during execution.

Lastly, we get to `foo()`: clearly, an argument is missing. Here, Elixir does object during compilation:
it complains that `foo/0` does not exist, meaning there is no `foo` function defined that takes `0` parameters.

So, while Elixir may not check that the argument types are correct, it does
check that the *number* of arguments matches the definition.

The number of parameters of a function is known as that function's *arity*, In the example
above, `foo` has arity `1` while `foo()` calls the function `foo` with arity 0.
In other words, `foo/1` exists, but not `foo/0`.

The arity allows for a limited form of overloading:
the same function name can be reused by multiple functions as long
as they have a different arity.

```elixir
def foo(), do: ...
def foo(x), do: ...
def foo(x, y), do: ...
```

Here, three functions are defined. They happen to have the same name `foo`,
but other than that, they are unrelated. The three functions
are denoted `foo/0`, `foo/1` and `foo/2`.

A consequence of this approach is that variadic functions cannot be defined in Elixir.
The examples below cannot be directly translated into Elixir:

```csharp
// C#
void Foo(params int[] xs) { ... }

Foo(1, 2, 3);
```

```python
def foo(*xs):
    ...

foo(1, 2, 3)
```

## Default Parameter Values

An annoying detail which we mention in case you happen to stumble upon it:
the overloading mechanism can clash with default parameters.
For example,

```elixir
# foo/1
def foo(x), do: ...

# foo/2 with default parameter value
def foo(x, y \\ 5), do: ...
```

The compiler will emit an audible groan in this case, since
when confronted with the call `foo(5)`, the compiler
cannot determine whether you intend to call `foo/1`
or `foo/2` with the second parameter set to 5.
