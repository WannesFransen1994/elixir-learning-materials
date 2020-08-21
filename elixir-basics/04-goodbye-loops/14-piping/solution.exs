defmodule Grades do
  def best_students(grades) do
    grades
    |> Enum.sort_by(fn {_, _, grade} -> grade end)
    |> Enum.reverse
    |> Enum.take(3)
    |> Enum.map(fn {_, name, _} -> name end)
  end
end
