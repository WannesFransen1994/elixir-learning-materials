defmodule ExerciseTest do
  use ExUnit.Case
  doctest Exercise

  test "say wise thing test" do
    assert Exercise.Sage.say_wise_thing() == "All life must be respected!"
  end
end
