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

  check(that: Util.increasing?([]), is_equal_to: true)
  check(that: Util.increasing?([1]), is_equal_to: true)
  check(that: Util.increasing?([1, 2]), is_equal_to: true)
  check(that: Util.increasing?([1, 1]), is_equal_to: true)
  check(that: Util.increasing?([1, 2, 3]), is_equal_to: true)
  check(that: Util.increasing?([1, 4, 6, 10]), is_equal_to: true)
  check(that: Util.increasing?([1, 4, 6, 10, 100, 1000]), is_equal_to: true)

  check(that: Util.increasing?([1, 0]), is_equal_to: false)
  check(that: Util.increasing?([5, 4, 3, 2, 1]), is_equal_to: false)
  check(that: Util.increasing?([1, 2, 3, 2, 3, 4]), is_equal_to: false)
end
