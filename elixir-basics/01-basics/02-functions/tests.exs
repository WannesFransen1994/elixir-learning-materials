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

  check(that: Temperature.kelvin_to_celsius(0), is_equal_to: -273.15)
  check(that: Temperature.kelvin_to_celsius(273.15), is_equal_to: 0)
  check(that: Temperature.kelvin_to_celsius(283.15), is_equal_to: 10)

  check(that: Temperature.celsius_to_kelvin(-273.15), is_equal_to: 0)
  check(that: Temperature.celsius_to_kelvin(0), is_equal_to: 273.15)
  check(that: Temperature.celsius_to_kelvin(10), is_equal_to: 283.15)
end
