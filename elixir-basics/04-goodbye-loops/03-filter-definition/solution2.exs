defmodule Util do
  def filter(xs, predicate, acc \\ [])
  def filter([], _, acc), do: Enum.reverse(acc)
  def filter([x|xs], predicate, acc) do
    if predicate.(x) do
      filter(xs, predicate, [x|acc])
    else
      filter(xs, predicate, acc)
    end
  end
end
