defmodule GameserverTest do
  use ExUnit.Case
  doctest Gameserver

  test "greets the world" do
    assert Gameserver.hello() == :world
  end
end
