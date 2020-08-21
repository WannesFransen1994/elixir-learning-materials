defmodule Counter do
  def counter(current \\ 0) do
    receive do
      pid -> send(pid, current)
    end

    counter(current + 1)
  end
end

pid = spawn(&Counter.counter/0)

send(pid, self())
receive do
  answer -> IO.puts(answer)
end

send(pid, self())
receive do
  answer -> IO.puts(answer)
end

send(pid, self())
receive do
  answer -> IO.puts(answer)
end
