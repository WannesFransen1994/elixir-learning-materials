defmodule Numbers do
  def abs(n) when is_number(n) and n >= 0, do: n
  def abs(n) when is_number(n) and n < 0, do: -n
end
