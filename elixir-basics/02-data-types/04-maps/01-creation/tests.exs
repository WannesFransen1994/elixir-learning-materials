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

  check that: Util.frequencies([]), is_equal_to: %{}
  check that: Util.frequencies([:a]), is_equal_to: %{a: 1}
  check that: Util.frequencies([:a, :a]), is_equal_to: %{a: 2}
  check that: Util.frequencies([:a, :b]), is_equal_to: %{a: 1, b: 1}
  check that: Util.frequencies([:a, :b, :b]), is_equal_to: %{a: 1, b: 2}
  check that: Util.frequencies([:a, :b, :b, :a]), is_equal_to: %{a: 2, b: 2}
  check that: Util.frequencies([:a, :b, :b, :a, :c]), is_equal_to: %{a: 2, b: 2, c: 1}
end
