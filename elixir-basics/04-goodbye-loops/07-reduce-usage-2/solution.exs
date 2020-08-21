defmodule Util do
  def count(xs, predicate) do
    Enum.reduce(xs, 0, fn x, acc ->
      if predicate.(x) do
        acc + 1
      else
        acc
      end
    end)
  end
end
