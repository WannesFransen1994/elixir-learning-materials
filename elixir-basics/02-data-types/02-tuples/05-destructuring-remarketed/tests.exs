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

  # Fallback case: no simplification possible
  check(that: Math.simplify(0), is_equal_to: 0)
  check(that: Math.simplify({:+, :a, :b}), is_equal_to: {:+, :a, :b})

  # x + 0 == 0 + x == 0
  check(that: Math.simplify({:+, :x, 0}), is_equal_to: :x)
  check(that: Math.simplify({:+, 0, :x}), is_equal_to: :x)

  # Recursive simplification
  check(that: Math.simplify({:+, 0, {:+, :x, 0}}), is_equal_to: :x)
  check(that: Math.simplify({:+, {:+, 0, :y}, {:+, :x, 0}}), is_equal_to: {:+, :y, :x})
  check(that: Math.simplify({:+, {:+, 0, {:/, :a, :b}}, 0}), is_equal_to: {:/, :a, :b})

  # Literals allow partial evaluation
  check(that: Math.simplify({:+, 1, 1}), is_equal_to: 1 + 1)
  check(that: Math.simplify({:+, 5, 8}), is_equal_to: 5 + 8)
  check(that: Math.simplify({:+, {:+, 1, 2}, {:+, 3, 4}}), is_equal_to: 1 + 2 + 3 + 4)
  check(that: Math.simplify({:+, {:+, 1, 2}, :x}), is_equal_to: {:+, 3, :x})

  # x - 0 == x
  check(that: Math.simplify({:-, :x, 0}), is_equal_to: :x)
  check(that: Math.simplify({:-, {:+, :x, :y}, 0}), is_equal_to: {:+, :x, :y})

  # x - x == 0
  check(that: Math.simplify({:-, :x, :x}), is_equal_to: 0)
  check(that: Math.simplify({:-, :y, {:-, :x, :x}}), is_equal_to: :y)

  # Literals allow partial evaluation
  check(that: Math.simplify({:-, 5, 3}), is_equal_to: 2)
  check(that: Math.simplify({:-, {:-, 4, 1}, {:-, 5, 3}}), is_equal_to: 1)

  # 0 * x == x * 0 == 0
  check(that: Math.simplify({:*, :x, 0}), is_equal_to: 0)
  check(that: Math.simplify({:*, 0, :x}), is_equal_to: 0)
  check(that: Math.simplify({:*, 4, {:*, 0, :x}}), is_equal_to: 0)
  check(that: Math.simplify({:+, 4, {:*, 0, :x}}), is_equal_to: 4)

  # 1 * x == x * 1 == x
  check(that: Math.simplify({:*, :x, 1}), is_equal_to: :x)
  check(that: Math.simplify({:*, 1, :x}), is_equal_to: :x)
  check(that: Math.simplify({:-, {:*, :x, 1}, {:*, 1, :x}}), is_equal_to: 0)
end
