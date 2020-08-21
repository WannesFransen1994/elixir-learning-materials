defmodule Util do
  def len(xs), do: Enum.reduce(xs, 0, fn (_, acc) -> acc + 1 end)
end
