defmodule Numbers do
  def maximum(a, b) do
    if a > b, do: a, else: b
  end

  def maximum(a, b, c) do
    maximum(maximum(a, b), c)
  end

  def maximum(a, b, c, d) do
    maximum(maximum(a, b), maximum(c, d))
  end
end
