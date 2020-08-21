defmodule Exercise do
  def repeat(0, _), do: nil
  def repeat(n, f) do
    f.()
    repeat(n-1, f)
  end

  def say_n_times(n, message) do
    repeat(n, fn ->
      :timer.sleep(100)
      IO.puts(message)
    end)
  end
end

spawn( fn -> Exercise.say_n_times(10, "foo") end )
spawn( fn -> Exercise.say_n_times(10, "bar") end )
:timer.sleep(1000)
