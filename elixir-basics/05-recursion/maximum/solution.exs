defmodule Exercise do
  def maximum([x]), do: x
  def maximum([x, y | xs]) do
    if x >= y do
      maximum([x | xs])
    else
      maximum([y | xs])
    end
  end
end
