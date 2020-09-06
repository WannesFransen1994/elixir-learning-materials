# Full version
defmodule Echo do
  def loop(next \\ nil) do
    receive do
      {:echo, message, from} ->
        shout_to(next, from, message)
        loop(next)

      {:update_next, new_next} ->
        loop(new_next)

      {:link, to} ->
        Process.link(to)
        loop(to)

      {:monitor, to} ->
        Process.monitor(to)
        loop(to)

      random_msg ->
        IO.puts("Random message:")
        IO.inspect(random_msg)
        loop(next)
    end
  end

  def shout_to(nil, f, m), do: shout(f, m)
  def shout_to(pid, f, m), do: send(pid, {:echo, shout(f, m), self()})

  defp shout(from, message) do
    :timer.sleep(50)
    echo_msg = "Echo from #{inspect(from)}: #{message}"
    IO.puts(echo_msg)
    echo_msg
  end
end

####################
# Unlinked section #
####################

pid_A = spawn(Echo, :loop, [])
pid_B = spawn(Echo, :loop, [])
pid_C = spawn(Echo, :loop, [])

send(pid_A, {:echo, "Hello world", self})

send(pid_A, {:update_next, pid_B})
send(pid_B, {:update_next, pid_C})

send(pid_A, {:echo, "Hello world", self})

Process.alive?(pid_A)
Process.alive?(pid_B)
Process.alive?(pid_C)
flush

###################
# Monitor section #
###################

# start processes
pid_A = spawn(Echo, :loop, [])
pid_B = spawn(Echo, :loop, [])
pid_C = spawn(Echo, :loop, [])

# Configure echo chain & monitor
send(pid_A, {:monitor, pid_B})
send(pid_B, {:monitor, pid_C})

# Test echo
send(pid_A, {:echo, "Hello world", self})

Process.exit(pid_B, :brutal_kill)

# Test echo and verify
send(pid_A, {:echo, "Hello world", self})
Process.alive?(pid_A)
Process.alive?(pid_B)
Process.alive?(pid_C)

################
# link section #
################

# trap exits
Process.flag(:trap_exit, true)

# start processes
pid_A = spawn(Echo, :loop, [])
pid_B = spawn(Echo, :loop, [])
pid_C = spawn(Echo, :loop, [])

Process.link(pid_A)

# Configure echo chain & link
send(pid_A, {:link, pid_B})
send(pid_B, {:link, pid_C})

# Test echo
send(pid_A, {:echo, "Hello world", self})

Process.exit(pid_B, :brutal_kill)
flush()

# Test echo and verify
send(pid_A, {:echo, "Hello world", self})
Process.alive?(pid_A)
Process.alive?(pid_B)
Process.alive?(pid_C)
