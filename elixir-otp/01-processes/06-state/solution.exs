defmodule Counter do
  def counter(parent_pid, current \\ 0) do
    receive do
      _ -> send(parent_pid, current)
    end

    counter(parent_pid, current + 1)
  end
end


parent_pid = self()
pid = spawn( fn -> Counter.counter(parent_pid) end )

send(pid, nil)
receive do
  answer -> IO.puts(answer)
end

send(pid, nil)
receive do
  answer -> IO.puts(answer)
end

send(pid, nil)
receive do
  answer -> IO.puts(answer)
end
