defmodule FictiveWebserverTest do
  use ExUnit.Case
  doctest FictiveWebserver

  test "greets the world" do
    assert FictiveWebserver.hello() == :world
  end
end
