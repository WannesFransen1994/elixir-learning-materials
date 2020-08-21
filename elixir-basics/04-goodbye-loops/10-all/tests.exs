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

  check(that: Grades.all_passed?([]), is_equal_to: true)
  check(that: Grades.all_passed?([0]), is_equal_to: false)
  check(that: Grades.all_passed?([9]), is_equal_to: false)
  check(that: Grades.all_passed?([10]), is_equal_to: true)
  check(that: Grades.all_passed?([10, 11]), is_equal_to: true)
  check(that: Grades.all_passed?([10, 11, 18]), is_equal_to: true)
  check(that: Grades.all_passed?([20]), is_equal_to: true)
  check(that: Grades.all_passed?([:na]), is_equal_to: true)
  check(that: Grades.all_passed?([10, 11, 5, 12]), is_equal_to: false)
  check(that: Grades.all_passed?([10, 11, 12, 8]), is_equal_to: false)
  check(that: Grades.all_passed?([10, 11, 12, :na, 8]), is_equal_to: false)
  check(that: Grades.all_passed?([10, 11, 12, :na]), is_equal_to: true)
end
