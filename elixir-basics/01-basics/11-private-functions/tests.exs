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

  check(that: Math.binomial(1, 0), is_equal_to: 1)
  check(that: Math.binomial(5, 0), is_equal_to: 1)
  check(that: Math.binomial(1, 1), is_equal_to: 1)
  check(that: Math.binomial(5, 1), is_equal_to: 5)
  check(that: Math.binomial(20, 1), is_equal_to: 20)
  check(that: Math.binomial(5, 2), is_equal_to: 10)
  check(that: Math.binomial(10, 2), is_equal_to: 45)
  check(that: Math.binomial(10, 5), is_equal_to: 252)
  check(that: Math.binomial(100, 50), is_equal_to: 100_891_344_545_564_193_334_812_497_256)
end
