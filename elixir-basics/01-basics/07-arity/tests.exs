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

  check(that: Numbers.maximum(1, 2), is_equal_to: 2)
  check(that: Numbers.maximum(3, 2), is_equal_to: 3)
  check(that: Numbers.maximum(1, 5, 2), is_equal_to: 5)

  check(that: Numbers.maximum(7, 5, 2), is_equal_to: 7)
  check(that: Numbers.maximum(7, 5, 9), is_equal_to: 9)
  check(that: Numbers.maximum(7, 10, 9), is_equal_to: 10)

  check(that: Numbers.maximum(3, 2, 1, 0), is_equal_to: 3)
  check(that: Numbers.maximum(3, 4, 1, 0), is_equal_to: 4)
  check(that: Numbers.maximum(3, 4, 7, 0), is_equal_to: 7)
  check(that: Numbers.maximum(3, 4, 7, 9), is_equal_to: 9)
end
