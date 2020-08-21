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
  import Integer

  check(that: Util.frequencies([]), is_equal_to: %{})
  check(that: Util.frequencies([:a]), is_equal_to: %{a: 1})
  check(that: Util.frequencies([:a, :a]), is_equal_to: %{a: 2})
  check(that: Util.frequencies([:a, :b]), is_equal_to: %{a: 1, b: 1})
  check(that: Util.frequencies([:a, :b, :b]), is_equal_to: %{a: 1, b: 2})
  check(that: Util.frequencies([:a, :b, :b, :a]), is_equal_to: %{a: 2, b: 2})
  check(that: Util.frequencies([:a, :b, :b, :a, :c]), is_equal_to: %{a: 2, b: 2, c: 1})
end
