defmodule Exercise do
  def print() do
    receive do
      message -> IO.puts(message)
    end

    print()
  end
end

pid = spawn(&Exercise.print/0)

send(pid, "a")
send(pid, "b")
send(pid, "c")
send(pid, "d")

:timer.sleep(1000)
