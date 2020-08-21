# Assignment

In this exercise, we show you how lambdas have a clear advantage over separate functions.

Consider the following code:

```elixir
def increment_by_1(x), do: x + 1
def increment_by_2(x), do: x + 2
def increment_by_3(x), do: x + 3
```

Now we want to create a function that returns the incrementer function corresponding to its parameter value:

```elixir
def create_incrementer(1), do: &increment_by_1/1
def create_incrementer(2), do: &increment_by_2/1
def create_incrementer(3), do: &increment_by_3/1
```

This code exhibits some obvious flaws:

* It feels a lot like copy pasting. Surely, there must be a better way of handling this.
* There is no reason to limit ourselves to steps of 1, 2 or 3. We want to be able to create incrementers for any value of `step`.

What we want is to be able to write something like

```elixir
def create_incrementer(step), do: ???
```

This is where *closures* come in.
When you create a lambda, it can refer to any variables that are
accessible to expressions. A concrete example:

```elixir
def create_incrementer(step), do: fn x -> x + step end
```

Here, the lambda's body `x + step` refers to two variables:

* `x`, which is simply its parameter.
* `step`, which is the parameter of its enclosing function.

Normally, referring to a variable owned by the enclosing function is risky,
as they get cleaned up after this enclosing function ends. In our case,
`step` should stop existing as soon as `create_incrementer` returns.
However, in Elixir, this poses no problem: local variables
can continue existing after their enclosing function ends.

In fact, closures are very intuitive: it's only when you start
thinking about the technical aspects of the internal implementation
that you realize it could cause trouble. So, contrary to C++, Elixir
gives you peace of mind: no need to worry about disappearing stack frames
or dangling references. Lambdas are free to refer to
any variable in scope.

## Task

Reimplement the `discount` exercise as follows:

* Create a private function `create_discounter(percentage)` that
  returns a function that  decreases its argument by `percentage`%.
  For example, `create_discounter(10).(100)` should return `90`,
* Have `discount` rely on `create_discounter` to create its
  functions. An example clause would be.

```elixir
def discount(:silver), do: create_discounter(10)
```
