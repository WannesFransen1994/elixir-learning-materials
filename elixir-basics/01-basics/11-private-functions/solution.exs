defmodule Math do
  defp factorial(0), do: 1
  defp factorial(n) when is_number(n) and n > 0, do: n * factorial(n - 1)

  def binomial(n, k), do: div(factorial(n), factorial(n - k) * factorial(k))
end
