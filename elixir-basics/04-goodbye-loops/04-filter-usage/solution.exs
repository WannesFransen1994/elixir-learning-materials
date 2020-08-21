defmodule Grades do
  def remove_na(grades) do
    Enum.filter(grades, fn x -> x != :na end)
  end
end
