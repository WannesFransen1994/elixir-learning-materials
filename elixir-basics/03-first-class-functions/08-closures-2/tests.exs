defmodule Functions do
  def fixedpoint(f, x) do
    y = f.(x)

    if x == y, do: x, else: fixedpoint(f, y)
  end
end

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

  check(that: Float.round(Math.sqrt(9)), is_equal_to: 3)
  check(that: Float.round(Math.sqrt(16)), is_equal_to: 4)
  check(that: Float.round(Math.sqrt(25)), is_equal_to: 5)
  check(that: Float.round(Math.sqrt(100)), is_equal_to: 10)
end
