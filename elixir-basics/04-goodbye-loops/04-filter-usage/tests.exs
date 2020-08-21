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
  import Integer

  check(that: Grades.remove_na([]), is_equal_to: [])
  check(that: Grades.remove_na([0]), is_equal_to: [0])
  check(that: Grades.remove_na([10]), is_equal_to: [10])
  check(that: Grades.remove_na([1, 2, 3]), is_equal_to: [1, 2, 3])
  check(that: Grades.remove_na([:na]), is_equal_to: [])
  check(that: Grades.remove_na([1, :na]), is_equal_to: [1])
  check(that: Grades.remove_na([1, :na, 2]), is_equal_to: [1, 2])
  check(that: Grades.remove_na([1, :na, 2, :na]), is_equal_to: [1, 2])
  check(that: Grades.remove_na([1, :na, 2, :na, 3]), is_equal_to: [1, 2, 3])
  check(that: Grades.remove_na([1, :na, 2, :na, :na, 3]), is_equal_to: [1, 2, 3])
  check(that: Grades.remove_na([:na, 1, :na, 2, :na, :na, 3]), is_equal_to: [1, 2, 3])
  check(that: Grades.remove_na([:na, 1, :na, 2, :na, :na, 3, :na]), is_equal_to: [1, 2, 3])

  check(
    that: Grades.remove_na([:na, 10, :na, 10, :na, :na, 10, 10, :na]),
    is_equal_to: [10, 10, 10, 10]
  )
end
