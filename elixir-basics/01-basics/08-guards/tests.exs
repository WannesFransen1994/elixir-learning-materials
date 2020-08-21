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

  check(that: Numbers.odd?(1), is_equal_to: true)
  check(that: Numbers.odd?(5), is_equal_to: true)
  check(that: Numbers.odd?(7), is_equal_to: true)
  check(that: Numbers.odd?(19), is_equal_to: true)
  check(that: Numbers.odd?(-19), is_equal_to: true)
  check(that: Numbers.odd?(0), is_equal_to: false)
  check(that: Numbers.odd?(2), is_equal_to: false)
  check(that: Numbers.odd?(4), is_equal_to: false)
  check(that: Numbers.odd?(80), is_equal_to: false)
  check(that: Numbers.odd?(-78), is_equal_to: false)

  check(that: Numbers.even?(0), is_equal_to: true)
  check(that: Numbers.even?(2), is_equal_to: true)
  check(that: Numbers.even?(8), is_equal_to: true)
  check(that: Numbers.even?(16), is_equal_to: true)
  check(that: Numbers.even?(-16), is_equal_to: true)
  check(that: Numbers.even?(1), is_equal_to: false)
  check(that: Numbers.even?(5), is_equal_to: false)
  check(that: Numbers.even?(-5), is_equal_to: false)

  must_raise(FunctionClauseError) do
    Numbers.odd?("abc")
  end

  must_raise(FunctionClauseError) do
    Numbers.even?("abc")
  end
end
