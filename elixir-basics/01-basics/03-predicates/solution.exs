defmodule Numbers do
  def odd?(x) do
    rem(x, 2) != 0
  end

  # Shorter notation for single-expression functions
  def even?(x), do: rem(x, 2) == 0
end
