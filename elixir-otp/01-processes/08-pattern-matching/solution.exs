defmodule Counter do
  def counter(current \\ 0) do
    receive do
      {:inc, pid} ->
        new_current = current + 1
        send(pid, new_current)
        counter(new_current)
      {:dec, pid} ->
        new_current = current - 1
        send(pid, new_current)
        counter(new_current)
    end
  end
end

pid = spawn(&Counter.counter/0)

send(pid, {:inc, self()})
receive do
  answer -> IO.puts(answer)
end

send(pid, {:inc, self()})
receive do
  answer -> IO.puts(answer)
end

send(pid, {:dec, self()})
receive do
  answer -> IO.puts(answer)
end
