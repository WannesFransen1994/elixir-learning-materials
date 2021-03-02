defmodule Solution do
  @moduledoc """
  Solution keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def generate_random_number_between(min, max) when is_integer(min) and is_integer(max) do
    :rand.uniform(max - min) + min
  end

  def generate_random_number_between(min, max) when is_binary(min) and is_binary(max) do
    min_parsed = String.to_integer(min)
    max_parsed = String.to_integer(max)
    generate_random_number_between(min_parsed, max_parsed)
  end
end
