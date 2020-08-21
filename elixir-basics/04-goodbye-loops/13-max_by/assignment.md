# Assignment

## Task

Write a function `Grades.best_student(grades)` that returns the name of the student with the highest grade.
`grades` is a list containing tuples with structure `{ id, name, grade }`.

For example, say `grades` is equal to

```elixir
grades = [ { "r0000000", "Kit", 11 },
           { "r0000001", "Sophie", 14 },
           { "r0000002", "Charles", 17 },
           { "r0000002", "Emilia", 7 },
           { "r0000003", "Peter", 18 } ]
```

According to this list, Peter is the top student. `best_student` should therefore
return `"Peter"`.

Rely on `Enum` functions to solve this exercise.
