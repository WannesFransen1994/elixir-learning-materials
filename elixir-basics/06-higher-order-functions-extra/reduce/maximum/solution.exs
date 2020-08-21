defmodule Util do
  def maximum([x | xs]), do: Enum.reduce(xs, x, fn (x, y) -> if x >= y, do: x, else: y end)
end
