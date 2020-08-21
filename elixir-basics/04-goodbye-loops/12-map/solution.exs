defmodule Grades do
  defp letter_for(g) when g in 0..7, do: "C"
  defp letter_for(g) when g in 8..9, do: "B"
  defp letter_for(g) when g in 10..20, do: "A"

  def to_code(grades) do
    Enum.join(Enum.map(grades, &letter_for/1))
  end
end
