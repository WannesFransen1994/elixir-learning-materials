defmodule Grades do
  def best_student(grades) do
    elem(Enum.max_by(grades, fn {_, _, g} -> g end), 1)
  end
end
