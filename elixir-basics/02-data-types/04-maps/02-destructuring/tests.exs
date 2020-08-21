defmodule Setup do
  @script "shared.exs"

  def setup(directory \\ ".") do
    path = Path.join(directory, @script)

    if File.exists?(path) do
      Code.require_file(path)
      Shared.setup(__DIR__)
    else
      setup(Path.join(directory, ".."))
    end
  end
end

Setup.setup


defmodule Tests do
  use ExUnit.Case, async: true
  import Shared

  check that: Util.follow(%{a: :b}, :x), is_equal_to: [ :x ]
  check that: Util.follow(%{a: :b}, :a), is_equal_to: [ :a, :b ]
  check that: Util.follow(%{a: :b, b: :c}, :a), is_equal_to: [ :a, :b, :c ]
  check that: Util.follow(%{a: :b, b: :c, c: :d}, :a), is_equal_to: [ :a, :b, :c, :d ]
  check that: Util.follow(%{a: :b, b: :c, c: :d}, :b), is_equal_to: [ :b, :c, :d ]
  check that: Util.follow(%{a: :b, b: :c, c: :d}, :c), is_equal_to: [ :c, :d ]
  check that: Util.follow(%{a: :b, b: :c, c: :d}, :d), is_equal_to: [ :d ]
end
