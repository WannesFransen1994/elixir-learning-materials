defmodule Counter do
  defp counter(current \\ 0) do
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

  def start() do
    spawn(&counter/0)
  end

  def inc(counter_pid) do
    send(counter_pid, :inc)
  end

  def dec(counter_pid) do
    send(counter_pid, :dec)
  end

  def get(counter_pid) do
    send(counter_pid, {:get, self()})

    receive do
      answer -> answer
    end
  end

  def reset(counter_pid) do
    send(counter_pid, :reset)
  end
end

counter = Counter.start()
Counter.inc(counter)
Counter.inc(counter)
Counter.inc(counter)
IO.puts(Counter.get(counter))

Counter.dec(counter)
IO.puts(Counter.get(counter))

Counter.reset(counter)
IO.puts(Counter.get(counter))
