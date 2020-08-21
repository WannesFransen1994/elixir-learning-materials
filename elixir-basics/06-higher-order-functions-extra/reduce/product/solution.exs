defmodule Math do
  def product(xs) do
    xs |> Enum.reduce(1, fn (x, acc) -> x * acc end)
  end
end
