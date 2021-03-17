defmodule Student do
  @moduledoc """
  Student keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def random_number do
    Enum.random(1..1000)
  end
end
