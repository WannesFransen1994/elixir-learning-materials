defmodule Util do
  def count([], _), do: 0
  def count([x|xs], predicate) do
    if predicate.(x) do
      1 + count(xs, predicate)
    else
      count(xs, predicate)
    end
  end
end
