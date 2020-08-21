defmodule Cards do
  def same_suit?({_, s}, {_, s}), do: true
  def same_suit?(_, _), do: false
end
