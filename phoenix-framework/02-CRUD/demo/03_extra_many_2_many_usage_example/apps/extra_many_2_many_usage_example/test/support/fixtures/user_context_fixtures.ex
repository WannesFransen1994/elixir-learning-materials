defmodule ExtraMany2ManyUsageExample.UserContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExtraMany2ManyUsageExample.UserContext` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ExtraMany2ManyUsageExample.UserContext.create_user()

    user
  end
end
