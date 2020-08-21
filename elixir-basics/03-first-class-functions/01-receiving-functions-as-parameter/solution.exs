defmodule Functions do
  def twice(f,  x), do: f.(f.(x))
end
