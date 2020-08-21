defmodule Oracle do
  # Module constant
  @answers { :yes, :maybe, :no }

  defp get_answer_for(question) do
    elem(@answers, rem(String.length(question), 3))
  end

  def magic_eight_ball(parent_pid) do
    receive do
      question -> send(parent_pid, get_answer_for(question))
    end

    magic_eight_ball(parent_pid)
  end
end


parent_pid = self()
pid = spawn( fn -> Oracle.magic_eight_ball(parent_pid) end )

send(pid, "")
receive do
  answer -> IO.puts(answer) # Should return :yes
end

send(pid, ".")
receive do
  answer -> IO.puts(answer) # Should return :maybe
end

send(pid, "..")
receive do
  answer -> IO.puts(answer) # Should return :no
end
