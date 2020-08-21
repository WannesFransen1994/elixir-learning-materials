# Assignment

Functions are central in Elixir, so it makes
sense it's one of the first things you learn.

Elixir requires functions to be part of a *module*.
You can compare this with C# or Java: these languages
expect all functions/methods to be part of a class.
This is where the similarities end, however.
Modules are merely a way of bundling
related functions together, similar to C# namespaces
or Java packages.

```elixir
defmodule Temperature do
  def kelvin_to_celsius(t) do
    t - 273.15
  end
end
```

Here, we have defined a module named `Temperature`.
It contains a single function, `kelvin_to_celsius`.

Note the following details:

* There is no mention of parameter types nor return type. Elixir is a *dynamically typed language* like Python and JavaScript, but unlike C#, C++ and Java.
* There is no `return`. In Elixir, a function automatically returns the value of the last evaluated expression. In other words, you can imagine
  there's a `return` before `t - 273.15`.

## Task

Add a function `celsius_to_kelvin` to the `Temperature` module.

## Running the Tests

To run the tests, run the following command in the shell:

```bash
$ elixir tests.exs
......

Finished in 0.06 seconds (0.06s on load, 0.00s on tests)
6 tests, 0 failures

Randomized with seed 166000
```
