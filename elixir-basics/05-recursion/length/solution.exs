defmodule Exercise do
  def len([]), do: 0
  def len([_|xs]), do: 1 + len(xs)
end
