defmodule Shop do
  defp standard(x), do: x
  defp bronze(x), do: x * 0.95
  defp silver(x), do: x * 0.9
  defp gold(x), do: x * 0.8


  def discount(:standard), do: &standard/1
  def discount(:bronze), do: &bronze/1
  def discount(:silver), do: &silver/1
  def discount(:gold), do: &gold/1
end
