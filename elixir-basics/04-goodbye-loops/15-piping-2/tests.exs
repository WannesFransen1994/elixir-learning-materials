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

  @s1 {"r0000000", "Stanley", 20}
  @s2 {"r0000001", "Sydney", 2}
  @s3 {"r0000002", "Claudia", 10}
  @s4 {"r0000003", "Rose", 17}
  @s5 {"r0000004", "Jimmy", 8}

  check(that: Grades.ranking([]), is_equal_to: "")
  check(that: Grades.ranking([@s1]), is_equal_to: "1. Stanley")
  check(that: Grades.ranking([@s1, @s2]), is_equal_to: "1. Stanley")
  check(that: Grades.ranking([@s1, @s2, @s3]), is_equal_to: "1. Stanley\n2. Claudia")

  check(
    that: Grades.ranking([@s1, @s2, @s3, @s4]),
    is_equal_to: "1. Stanley\n2. Rose\n3. Claudia"
  )

  check(
    that: Grades.ranking([@s1, @s2, @s3, @s4, @s5]),
    is_equal_to: "1. Stanley\n2. Rose\n3. Claudia"
  )

  check(
    that: Grades.ranking([@s3, @s1, @s4, @s5, @s2]),
    is_equal_to: "1. Stanley\n2. Rose\n3. Claudia"
  )

  check(
    that: Grades.ranking([@s4, @s3, @s1, @s5, @s2]),
    is_equal_to: "1. Stanley\n2. Rose\n3. Claudia"
  )
end
