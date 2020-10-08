defmodule FactorialWorkerTest do
  use ExUnit.Case
  doctest FactorialWorker

  test "greets the world" do
    assert FactorialWorker.hello() == :world
  end
end
