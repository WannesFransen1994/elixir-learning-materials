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

  check(that: Store.total_cost(%{a: 5}, [:a]), is_equal_to: 5)
  check(that: Store.total_cost(%{a: 10}, [:a]), is_equal_to: 10)
  check(that: Store.total_cost(%{a: 5}, [:a, :a]), is_equal_to: 10)
  check(that: Store.total_cost(%{a: 5, b: 2}, [:a, :b]), is_equal_to: 7)
  check(that: Store.total_cost(%{a: 5, b: 2, c: 7}, [:a]), is_equal_to: 5)
  check(that: Store.total_cost(%{a: 5, b: 2, c: 7}, [:b]), is_equal_to: 2)
  check(that: Store.total_cost(%{a: 5, b: 2, c: 7}, [:c]), is_equal_to: 7)
  check(that: Store.total_cost(%{a: 8, b: 10, c: 5}, [:c]), is_equal_to: 5)
  check(that: Store.total_cost(%{a: 8, b: 10, c: 5}, [:c, :a]), is_equal_to: 5 + 8)
  check(that: Store.total_cost(%{a: 8, b: 10, c: 5}, [:c, :a, :b]), is_equal_to: 5 + 8 + 10)
end
