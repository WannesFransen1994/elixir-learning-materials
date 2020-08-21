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

  check(that: Shop.discount(:standard).(10), is_equal_to: 10)
  check(that: Shop.discount(:standard).(50), is_equal_to: 50)
  check(that: Shop.discount(:bronze).(50), is_equal_to: 50 * 0.95)
  check(that: Shop.discount(:bronze).(100), is_equal_to: 100 * 0.95)
  check(that: Shop.discount(:silver).(100), is_equal_to: 100 * 0.9)
  check(that: Shop.discount(:silver).(400), is_equal_to: 400 * 0.9)
  check(that: Shop.discount(:gold).(400), is_equal_to: 400 * 0.8)
  check(that: Shop.discount(:gold).(1000), is_equal_to: 1000 * 0.8)
end
