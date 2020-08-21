defmodule Util do
  # Tail recursive version
  def count(xs, predicate, acc \\ 0)
  def count([], _, acc), do: acc
  def count([x|xs], predicate, acc) do
    if predicate.(x) do
      count(xs, predicate, acc + 1)
    else
      count(xs, predicate, acc)
    end
  end
end
