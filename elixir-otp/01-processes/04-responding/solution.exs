defmodule Exercise do
  def print(parent_pid) do
    receive do
      message ->
        IO.puts(message)
        send(parent_pid, :success)
    end

    print(parent_pid)
  end
end

parent_pid = self()
pid = spawn(fn -> Exercise.print(parent_pid) end)

send(pid, "a")
send(pid, "b")
send(pid, "c")
send(pid, "d")

receive do
  _ -> nil
end

receive do
  _ -> nil
end

receive do
  _ -> nil
end

receive do
  _ -> nil
end
