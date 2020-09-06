defmodule Echo do
  defp shout_to(nil, from, msg) do
    shout(from, msg)
  end

  defp shout_to(pid, from, msg) do
    echo_msg = shout(from, msg)
    send(pid, {:echo, echo_msg, self()})
  end

  defp shout(from, msg) do
    :timer.sleep(50)
    echo_msg = "#{inspect(from)}: #{msg}"
    IO.puts("\n" <> echo_msg)
    echo_msg
  end
end
