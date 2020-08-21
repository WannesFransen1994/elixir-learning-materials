defmodule Util do
  def frequencies(xs) do
    Enum.reduce(xs, %{}, fn x, acc ->
      Map.update(acc, x, 1, fn n -> n + 1 end)
    end)
  end
end
