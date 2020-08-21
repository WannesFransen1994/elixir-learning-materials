defmodule Math do
  def sqrt(x) do
    Functions.fixedpoint(fn y -> y - (y * y - x) / (2 * x) end, x)
  end
end
