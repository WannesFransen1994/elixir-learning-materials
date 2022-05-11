defmodule DemoAssociations.TaskContextTest do
  use DemoAssociations.DataCase

  alias DemoAssociations.TaskContext

  describe "tasks" do
    alias DemoAssociations.TaskContext.Task

    import DemoAssociations.TaskContextFixtures

    @invalid_attrs %{title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert TaskContext.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert TaskContext.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Task{} = task} = TaskContext.create_task(valid_attrs)
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskContext.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Task{} = task} = TaskContext.update_task(task, update_attrs)
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskContext.update_task(task, @invalid_attrs)
      assert task == TaskContext.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = TaskContext.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> TaskContext.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = TaskContext.change_task(task)
    end
  end
end
