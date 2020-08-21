defmodule Exercise do
  def flatten([x | xs]) when is_list(x), do: flatten(x) ++ flatten(xs)
  def flatten([x | xs]), do: [x | flatten(xs)]
  def flatten([]), do: []
end
