# Assignment

Say you define a function like shown below.

```elixir
# Elixir
defmodule Foo do
    def bar() do
        ...
    end
end
```

In this case, everyone is allowed to call `bar`:
from outside the module, you can simply write `Foo.bar`.
In other words, this function is *public*.

Sometimes, however, functions will grow to an
uncomfortable size and you'll want to split them
up, spreading complexity across multiple functions.
However, these helper functions are often not
meant for others to use, meaning
you'd like to keep them private.

Elixir lets you define private functions as follows:

```elixir
# Elixir
defmodule Foo do
    defp bar() do
        ...
    end
end
```

Note the extra `p` in `defp`. That's all there is to it.
Now `bar` is only accessible to other functions in the same module.

## Task

Define a private function `Math.factorial(n)` that computes
`n` factorial, also written "`n`"!. This is defined as follows:

* 0! equals 1
* k! equals k &times; (k-1)!

For example, 5! is equal to 1 &times; 2 &times; 3 &times; 4 &times; 5 = 120.

Next, define a public function `Math.binomial(n, k)` that computes
n! / (k! &times; (n-k)!).

Note the following:

* Factorials can grow large very quickly. This is no issue for Elixir:
  contrary to Java, C# or C++, integers are not limited in size. They'll consume
  the bits necessary to faithfully represent the number.
* Do not use the `/` operator for division: it always produces floating point numbers and the tests expect integers.
  Look up how to perform integer division.
