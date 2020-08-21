defmodule Math do
  def range_sum(b, a \\ 0, step \\ 1) when is_number(a) and is_number(b) and is_number(step) do
    if b >= a do
      a + range_sum(b, a + step, step)
    else
      0
    end
  end
end
