defmodule Functions do
  def compose([], x), do: x
  def compose([f | fs], x), do: compose(fs, f.(x))
end
