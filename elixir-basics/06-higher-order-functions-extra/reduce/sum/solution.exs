defmodule Math do
  def sum(xs), do: Enum.reduce(xs, 0, fn (x, acc) -> x + acc end)
end
