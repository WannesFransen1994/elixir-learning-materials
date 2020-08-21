defmodule Bank do
  def largest_expense_index(balance_history) do
    balance_history
    |> Enum.zip(tl(balance_history))
    |> Enum.map(fn {x, y} -> y - x end)
    |> Enum.with_index(0)
    |> Enum.min_by(fn {x, _} -> x end)
    |> elem(1)
  end
end
