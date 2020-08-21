defmodule Functions do
  def nest(_, 0, x), do: x
  def nest(f, k, x), do: nest(f, k - 1, f.(x))
end
