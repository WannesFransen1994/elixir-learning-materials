defmodule Util do
  def range(a, b), do: calcrange(a, b, [])
  defp calcrange(a, b, acc) when b < a, do: acc
  defp calcrange(a, b, acc), do: calcrange(a, b - 1, [b | acc])
end
