defmodule DemoAssociations.UserContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DemoAssociations.UserContext` context.
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
      |> DemoAssociations.UserContext.create_user()

    user
  end
end
