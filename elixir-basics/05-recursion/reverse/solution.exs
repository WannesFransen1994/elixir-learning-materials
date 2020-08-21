defmodule Exercise do
  def reverse([]), do: []
  def reverse([x | xs]), do: reverse(xs) ++ [x]
end
