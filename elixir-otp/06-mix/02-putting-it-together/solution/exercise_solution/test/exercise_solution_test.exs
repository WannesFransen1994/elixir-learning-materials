defmodule ExerciseSolutionTest do
  use ExUnit.Case
  doctest ExerciseSolution

  test "greets the world" do
    assert ExerciseSolution.hello() == :world
  end
end
