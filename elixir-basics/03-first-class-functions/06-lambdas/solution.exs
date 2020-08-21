defmodule Shop do
  def discount(:standard), do: &(&1)
  def discount(:bronze), do: &(&1 * 0.95)
  def discount(:silver), do: fn x -> x * 0.9 end
  def discount(:gold), do: fn x -> x * 0.8 end
end
