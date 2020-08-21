defmodule Util do
  def filter([], predicate), do: []
  def filter([x|xs], predicate) do
    if predicate.(x) do
      [ x | filter(xs, predicate) ]
    else
      filter(xs, predicate)
    end
  end
end
