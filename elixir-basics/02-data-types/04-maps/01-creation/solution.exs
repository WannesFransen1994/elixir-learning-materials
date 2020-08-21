defmodule Util do
  def frequencies([]), do: %{}
  def frequencies([x|xs]) do
    f = frequencies(xs)
    Map.put(f, x, Map.get(f, x, 0) + 1)
  end
end
