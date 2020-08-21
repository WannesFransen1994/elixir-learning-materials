defmodule Grades do
  def passed_percentage(grades) do
    round(Enum.count(grades, fn n -> n >= 10 end) / length(grades) * 100)
  end
end
