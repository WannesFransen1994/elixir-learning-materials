# Assignment

In the previous exercises, you've been passing functions as parameters.
Now, it is time for you to take the next step: returning them.

Let's start simple.
Say you have a function `foo`:

```elixir
defmodule Foo do
    def foo(x) do
        ...
    end
end
```

If you want to "pick up" `foo` as if it were a value, you need to use a special syntax in Elixir, namely
`&Foo.foo/1`. The ampersand indicates "I am referring to a function here", the `/1` corresponds to the arity.
As [explained previously](/docs/compiler-checks.md), Elixir allows overloading, i.e., multiple
functions sharing the same name, as long as their arity differs.

```elixir
defmodule Foo do
    # Referred to using &Foo.foo/0
    def foo() do
        ...
    end

    # Referred to using &Foo.foo/1
    def foo(x) do
        ...
    end

    # Referred to using &Foo.foo/2
    def foo(x, y) do
        ...
    end
end
```

Once you "hold" the function, you can do whatever you want with it:

```elixir
# Store it in a variable
f = &Foo.foo/1

# Pass it as argument
some_function(&Foo.foo/1)

# Return it
def bar() do
    &Foo.foo/1
end
```

## Task

There are four different ranks of customers: `:standard`, `:bronze`, `:silver` or `:gold`.
Depending on their rank, customers receive a certain discount:

|Rank|Discount|
|-|-|
|Standard | 0% |
|Bronze | 5% |
|Silver | 10% |
|Gold | 20% |

Create a function `Shop.discount(rank)` that returns a function that adjusts the price of items
for customers depending on the given rank. For example, `discount(:silver)` should return
a function that, given a price, returns it with a discount of 10%.

```elixir
price_calc = Shop.discount(:silver)
# price_calc is now a function

# We need to use the special function call syntax .()
price_calc.(100) # Returns 90
price_calc.(1000) # Returns 900

price_calc = Shop.discount(:standard)
price_calc.(100) # Returns 100
price_calc.(1000) # Returns 1000
```

For those not knowing how to start:

* Define a private function `standard` that, given a price, simply returns it. This corresponds to no discount.
* Define a private function `bronze` that, given a price, returns it reduced by 5%.
* Do the same for `silver` and `gold`.
* Lastly, define a public function `discount` that depending on its argument, returns `standard`, `bronze`, `silver` or `gold`.
