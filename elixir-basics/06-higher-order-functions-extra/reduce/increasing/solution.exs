defmodule Util do
  def increasing?([]), do: true
  def increasing?(ns), do: ns |> Enum.zip(tl(ns)) |> Enum.reduce(true, fn ({x, y}, acc) -> acc and x <= y end)
end
