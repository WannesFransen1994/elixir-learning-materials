# Tail recursive
defmodule Util do
  defp replace_at([_|xs], 0, y, acc), do: Enum.reverse(acc) ++ [y|xs]
  defp replace_at([x|xs], index, y, acc) when index > 0, do: replace_at(xs, index - 1, y, [x | acc])

  def replace_at(xs, index, y), do: replace_at(xs, index, y, [])
end
