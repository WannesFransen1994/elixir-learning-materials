defmodule Numbers do
  def sign(n) do
    cond do
      n > 0 -> 1
      n < 0 -> -1
      true  -> 0
    end
  end
end
