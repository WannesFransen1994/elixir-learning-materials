# Assignment

## Task

Write a function `Grades.ranking(grades)` that returns a ranking of all students who passed.
`grades` is a list of tuples `{ id, name, grade }`.

For example, say your input is

```elixir
[
    { "r1354842", "Tony", 20 },
    { "r9098187", "Stephen", 16 },
    { "r5464879", "Steve", 14 },
    { "r8465166", "Bruce", 19 },
    { "r4684655", "Scott", 13 },
    { "r1357986", "Peter", 18 },
]
```

then `ranking` should return a string

```text
1. Tony
2. Bruce
3. Peter
4. Stephen
5. Steve
6. Scott
```

Hint: below are the operations you might need, listed in random order.

* `with_index`
* `filter`
* `sort_by`
* `join`
* `reverse` (optional)
* `map`
