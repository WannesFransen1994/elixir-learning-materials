defmodule ConfigDemoTest do
  use ExUnit.Case
  doctest ConfigDemo

  test "greets the world" do
    assert ConfigDemo.hello() == :world
  end
end
