defmodule Functions do
  def fixedpoint(f, x) do
    y = f.(x)

    if x == y, do: x, else: fixedpoint(f, y)
  end
end
