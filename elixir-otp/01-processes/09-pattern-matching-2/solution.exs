defmodule Counter do
  def counter(current \\ 0) do
    receive do
      :inc ->
        counter(current + 1)
      :dec ->
        counter(current - 1)
      :reset ->
        counter(0)
      {:get, sender_pid} ->
        send(sender_pid, current)
        counter(current)
    end
  end
end

pid = spawn(&Counter.counter/0)

send(pid, :inc)
send(pid, :inc)
send(pid, :inc)

send(pid, {:get, self()})
receive do
  answer -> IO.puts(answer)
end

send(pid, :dec)

send(pid, {:get, self()})
receive do
  answer -> IO.puts(answer)
end

send(pid, :reset)

send(pid, {:get, self()})
receive do
  answer -> IO.puts(answer)
end

