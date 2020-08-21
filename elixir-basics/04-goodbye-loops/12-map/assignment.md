# Assignment

## Task

Write a function `Grades.to_code(grades)` that turns the list of grades `grades` into a string, following these rules:

* Grades between 0 and 7 become the letter `C`.
* Grades 8 and 9 become the letter `B`.
* Grades above 10 become the letter `A`.

Use `Enum.map` to solve this exercise.

* First, translate each grade to its corresponding letter. This results in a list of one-lettered strings.
* [Join](https://lmgtfy.com/?q=elixir+join+strings) these strings together to produce one single string.
