defmodule Util do
  def replace_at([_|xs], 0, y), do: [y|xs]
  def replace_at([x|xs], index, y) when index > 0, do: [x | replace_at(xs, index - 1, y)]
end
