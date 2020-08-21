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

  def inc(x), do: x + 1
  def dbl(x), do: x * 2
  def sqr(x), do: x * x

  check(that: Functions.nest(&inc/1, 0, 1), is_equal_to: 1)
  check(that: Functions.nest(&inc/1, 1, 1), is_equal_to: 2)
  check(that: Functions.nest(&inc/1, 2, 1), is_equal_to: 3)
  check(that: Functions.nest(&inc/1, 100, 0), is_equal_to: 100)
  check(that: Functions.nest(&dbl/1, 2, 1), is_equal_to: 4)
  check(that: Functions.nest(&dbl/1, 3, 1), is_equal_to: 8)
  check(that: Functions.nest(&dbl/1, 4, 1), is_equal_to: 16)
  check(that: Functions.nest(&sqr/1, 4, 1), is_equal_to: 1)
  check(that: Functions.nest(&sqr/1, 4, 2), is_equal_to: 256 * 256)
end
