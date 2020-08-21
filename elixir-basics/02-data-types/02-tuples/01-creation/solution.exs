defmodule Math do
  def quotrem(x, y) when is_number(x) and is_number(y), do: { div(x, y), rem(x, y) }
end
