defmodule Shop do
  defp create_discounter(percentage), do: fn x -> x * (1 - percentage / 100) end

  def discount(:standard), do: create_discounter(0)
  def discount(:bronze), do: create_discounter(5)
  def discount(:silver), do: create_discounter(10)
  def discount(:gold), do: create_discounter(20)
end
