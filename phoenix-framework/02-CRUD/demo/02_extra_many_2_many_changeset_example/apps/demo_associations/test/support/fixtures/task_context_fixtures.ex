defmodule DemoAssociations.TaskContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DemoAssociations.TaskContext` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> DemoAssociations.TaskContext.create_task()

    task
  end
end
