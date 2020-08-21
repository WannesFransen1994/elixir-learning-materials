# Assignment

## First Class Functions

Start by reading [this text](/docs/loops.md).

We'll first focus on functions: you'll need to be comfortable
using them before we proceed.

Of course, functions are no strangers to you:
as good as any language features them.
However, their rank in the "language's society"
can vary.

There are three "social classes", inventively called the first,
second and third class. The table below shows the differences between each:

| | First | Second | Third |
|-|-|-|-|
|Passed as parameter| yes | yes | no |
|Returned as value| yes | no | no |
|Stored in variable| yes | no | no |

Let's give a few examples in Java:

* It should be obvious that integer values are first class citizens: `int x = 5`, `obj.method(7)` and `return 10;` are all valid.
* Packages are third class citizens: `obj.method(java.lang.util)` will be rejected by the compiler.
* Types are a bit more tricky. `return int;` will obviously not work, so clearly they are not first class. But can we pass them as parameters? In Java,
  there are *type parameters* (e.g. `String` in `ArrayList<String>`), but those only work for reference types (i.e., no `int`, `double` or `boolean`).
  So, depending on whether you feel type parameters count as "passing as parameter", reference types are second or third class. Primitive types are definitely
  third class in Java.

Note that first, second and third class are just labels and are not really important. What matters is what capabilities each language
concept has. Intuitively, you can think of first class citizens as things you can "hold" or "move around."

Now, let us turn our attention to functions. Pre-Java 8, functions/methods were third class citizens:
the only valid operation on functions was to invoke them: `obj.foo()`. Simply mentioning `foo` without `()` would be an error.
In Java 8 though, they were upgraded to first class. Types were introduced so that you could declare variables
and parameters to accept function objects:

```java
// Java
Function<Integer, Integer> func = Math::abs;

System.out.println(func.apply(-2)); // prints 2
```

There's nothing special about the `Function` type: it is a simple interface as shown below.

```java
// Java
interface Function<T, R>
{
    T apply(R r);
}
```

`Function<Integer, Integer> func = Math::abs` declares a variable `func` and assigns the existing method `Math::abs` to it.
In reality, the compiler actually defines a new class that implements `Function<Integer, Integer>` and
defines `apply` so that it calls `Math.abs` on its parameter.
`func.apply(-2)` simply returns `2`, as it is defined as absolute value.
Note how the function call syntax is different: given that `func` is a function, you'd
expect `func(-5)` to work, but Java sees `func` as a regular object, meaning
you need to fall back to standard method calling syntax.

Being able to treat functions as first class citizens is very helpful. Think of the Strategy,
Observer or Factory design patterns: their implementation can be simplified dramatically
when being able to use functions like this.

It won't surprise you to hear that Elixir's functions are first class.

## Calling Functions

Consider the code below:

```elixir
# Elixir
defmodule Hello do
  def hello() do
    IO.puts('hello')
  end
end

# Have func refer to hello
func = &Hello.hello/0

# Call hello directly
Hello.hello()

# Call via func
func.()
```

You can ignore the weird `&Hello.hello/0` syntax for now, we'll explain that later.
You can imagine it means `func = Hello.hello`, but using
this intuitive syntax would lead to ambiguities.

Note the difference in function calling: if you refer to the function directly by name,
the familiar `()` syntax works. If, however, the function is stored in a variable (such as `func`),
the slightly longer syntax `.()` needs to be used.

## Task

Write a function `Functions.twice(f, x)` that given a unary function `f` (i.e., a function that
takes one parameter) and a variable `x`, applies `f` twice in succession on `x`.
For example, say `f` doubles its argument, e.g. `f(2)` returns `4`,
then `twice(f, 2)` should return `8`.
