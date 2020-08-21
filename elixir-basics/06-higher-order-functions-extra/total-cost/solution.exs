defmodule Store do
  def total_cost(prices, basket) do
    basket
    |> Enum.map(fn item -> prices[item] end)
    |> Enum.sum()
  end
end
