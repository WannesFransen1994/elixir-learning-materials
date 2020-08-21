defmodule Math do
  def factorial(n) do
    Enum.reduce(1..n, 1, fn x, y -> x * y end)
  end
end
