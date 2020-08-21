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

  check(that: Util.reduce([], 0, &+/2), is_equal_to: 0)
  check(that: Util.reduce([1], 0, &+/2), is_equal_to: 1)
  check(that: Util.reduce([1, 1], 0, &+/2), is_equal_to: 2)
  check(that: Util.reduce([1, 2], 0, &+/2), is_equal_to: 3)
  check(that: Util.reduce([1, 2, 3], 0, &+/2), is_equal_to: 6)
  check(that: Util.reduce([1, 2, 3], 5, &+/2), is_equal_to: 11)
  check(that: Util.reduce([1, 2, 3], 1, &*/2), is_equal_to: 6)
  check(that: Util.reduce([2, 3], 1, &*/2), is_equal_to: 6)
  check(that: Util.reduce([2, 3, 4], 1, &*/2), is_equal_to: 24)
  check(that: Util.reduce([2, 3, 4], 0, &*/2), is_equal_to: 0)
  check(that: Util.reduce([true, true, true], true, fn x, y -> x && y end), is_equal_to: true)

  check(
    that: Util.reduce([true, true, true, true, true], true, fn x, y -> x && y end),
    is_equal_to: true
  )

  check(that: Util.reduce([true, false, true], true, fn x, y -> x && y end), is_equal_to: false)
  check(that: Util.reduce([3, 2, 1], 10, fn x, acc -> acc - x end), is_equal_to: 4)
end
