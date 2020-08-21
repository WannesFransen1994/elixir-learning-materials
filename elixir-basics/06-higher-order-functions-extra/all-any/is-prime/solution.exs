defmodule Math do
  defp range(a, b) when a < b, do: a..(b-1)
  defp range(_, _), do: []

  def prime?(n) do
    n > 1 and range(2, n) |> Enum.all?(fn k -> rem(n, k) != 0 end)
  end
end
