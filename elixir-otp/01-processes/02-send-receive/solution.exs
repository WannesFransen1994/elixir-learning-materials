defmodule Exercise do
  def print() do
    receive do
      message -> IO.puts(message)
    end
  end
end

pid = spawn(&Exercise.print/0)

send(pid, "Hello")
:timer.sleep(1000)
