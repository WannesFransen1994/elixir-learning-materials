defmodule Util do
  def replace_at(xs, index, y) do
    xs
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
         if i == index, do: y, else: x
       end)
  end
end
