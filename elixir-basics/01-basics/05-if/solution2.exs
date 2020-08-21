defmodule Numbers do
  def abs(n) do
    # Using single line if
    if n >= 0, do: n, else: -n
  end
end
