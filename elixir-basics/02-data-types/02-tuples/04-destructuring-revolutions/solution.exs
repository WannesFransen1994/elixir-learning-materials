defmodule Math do
  def evaluate(x) when is_number(x), do: x
  def evaluate({:+, x, y}), do: evaluate(x) + evaluate(y)
  def evaluate({:-, x, y}), do: evaluate(x) - evaluate(y)
  def evaluate({:*, x, y}), do: evaluate(x) * evaluate(y)
  def evaluate({:/, x, y}), do: evaluate(x) / evaluate(y)
end
