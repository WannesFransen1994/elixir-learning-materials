# Assignment

Say you need to build a string in which a variable's value appears,
for example as part of a `greet` function that given a `name` returns
a string `Hello, <name>`. Many languages offer string interpolation
to aid you. For example, in Python (since version 3.6) you can write

```python
def greet(name):
    return f"Hello, {name}"
```

Calling `greet("Joe")` will return `"Hello, Joe"`.

Elixir provides the same concept using a slightly different syntax:

```elixir
def greet(name) do
    "Hello, #{name}"
```

## Task

Write a function `DatePrinter.format(day, month, year)` that formats
the date as "day-month-year".
