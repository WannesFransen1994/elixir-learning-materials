# Assignment

Functional programmers like organizing their code as a single expression.
This is quite the opposite of the imperative styles, where piling
up everything in a single statement is frowned upon.
This isn't a big deal in functional programming languages
because they often offer syntactic support to keep it readable.

A quick example: say you want to perform the following operations, one after the other:

* Filtering
* Mapping
* Counting

Using the regular syntax, we would get

```elixir
Enum.count( Enum.map( Enum.filter( xs, fn x -> ... end ), fn x -> ... end ), fn x -> ... end )
```

This code is quite unreadable:

* The operations are listed in reversed order.
* It is difficult to see which lambda belongs to which function.
* With more elaborate lambdas, the line would become exceedingly long.

Please never write such code.

We could try to alleviate the chaos by spreading it over multiple lines:

```elixir
Enum.count( Enum.map( Enum.filter( xs,
                                   fn x -> ... end ),
                      fn x -> ... end ),
            fn x -> ... end )
```

We're not sure this is an improvement.
A better solution consists of splitting it up in multiple assignments:

```elixir
filtered        = Enum.filter( xs, fn x -> ... end )
mapped_filtered = Enum.map( filtered, fn x -> ... end )
count           = Enum.count( mapped_filtered, fn x -> ... end )
```

This is slightly better, but it burdens us with needing to invent descriptive names for all intermediate variables
and having to ascertain no mistakes are made in the chaining order.

Another approach would be to make use of Elixir's pipe operator `|>`. Applying it to the previous situation gives

```elixir
xs
|> Enum.filter( fn x -> ... end )
|> Enum.map( fn x -> ... end )
|> Enum.count( fn x -> ... end )
```

While it is not strictly necessary to spread this code over multiple lines, we strongly advise
you to do so for readability's sake. Also note a strange detail: `filter`, `map` and `count` normally
take two arguments, whereas we clearly only specify one. This is due to the piping operator:
`a |> f` implicitly turns `a` into `f`'s first parameter. In other words,
`a |> f |> g |> h` is actually the same as `h(g(f(a))`: start with `a`, then apply `f`, then
apply `g`, then apply `h`. The advantage of using the piping notation is that
the operations appear in order of execution: `filter` appears first, and it is also the first operation to take place.

## Task

Write a function `Grades.best_students(grades)` that returns the names of the top three students.
Write it as a single expression, relying on pipes to connect the successive operations.

Hint: these are the operations you need:

* `Enum.sort_by`
* `Enum.reverse` (optional if you're smart at the `sort_by` step)
* `Enum.take`
* `Enum.map`
