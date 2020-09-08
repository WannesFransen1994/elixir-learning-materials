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

  check(that: Math.prime?(0), is_equal_to: false)
  check(that: Math.prime?(1), is_equal_to: false)
  check(that: Math.prime?(2), is_equal_to: true)
  check(that: Math.prime?(3), is_equal_to: true)
  check(that: Math.prime?(4), is_equal_to: false)
  check(that: Math.prime?(5), is_equal_to: true)
  check(that: Math.prime?(6), is_equal_to: false)
  check(that: Math.prime?(7), is_equal_to: true)
  check(that: Math.prime?(8), is_equal_to: false)
  check(that: Math.prime?(9), is_equal_to: false)
  check(that: Math.prime?(10), is_equal_to: false)
  check(that: Math.prime?(11), is_equal_to: true)
  check(that: Math.prime?(97), is_equal_to: true)
  check(that: Math.prime?(100), is_equal_to: false)
  check(that: Math.prime?(541), is_equal_to: true)
end
