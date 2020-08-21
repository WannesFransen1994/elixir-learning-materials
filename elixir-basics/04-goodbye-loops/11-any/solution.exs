defmodule Grades do
  def any_tolerable?(grades) do
    Enum.any?(grades, fn x -> x in 8..9 end)
  end
end
