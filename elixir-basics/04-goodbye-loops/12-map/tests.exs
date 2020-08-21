defmodule Setup do
  @script "shared.exs"
  require Logger

  def setup(_directory, 0, attempted_locations) do
    Logger.error("Could not find #{@script} at the attempted locations:
    \n#{Enum.join(attempted_locations, "\n")}")

    raise "Could not find #{@script}"
  end

  def setup(directory, n, attempted_locations) do
    path = Path.join(directory, @script)

    if File.exists?(path) do
      Code.require_file(path)
      Shared.setup(__DIR__)
    else
      absolute_folder_loc = path |> Path.absname() |> Path.expand()
      setup(Path.join(directory, ".."), n - 1, [absolute_folder_loc | attempted_locations])
    end
  end
end

Setup.setup(".", 5, [])

defmodule Tests do
  use ExUnit.Case, async: true
  import Shared

  check(that: Grades.to_code([]), is_equal_to: "")
  check(that: Grades.to_code([0]), is_equal_to: "C")
  check(that: Grades.to_code([7]), is_equal_to: "C")
  check(that: Grades.to_code([8]), is_equal_to: "B")
  check(that: Grades.to_code([9]), is_equal_to: "B")
  check(that: Grades.to_code([10]), is_equal_to: "A")
  check(that: Grades.to_code([20]), is_equal_to: "A")
  check(that: Grades.to_code([20, 20]), is_equal_to: "AA")
  check(that: Grades.to_code([20, 20, 10]), is_equal_to: "AAA")
  check(that: Grades.to_code([0, 9, 10]), is_equal_to: "CBA")
  check(that: Grades.to_code([11, 8, 5]), is_equal_to: "ABC")
  check(that: Grades.to_code([11, 8, 5, 12, 9, 1]), is_equal_to: "ABCABC")
end
