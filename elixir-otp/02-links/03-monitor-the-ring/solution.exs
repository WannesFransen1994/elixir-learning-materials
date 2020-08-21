defmodule Linkable do
  def start(), do: spawn(&loop/0)
  def link(a, b) when is_pid(a) and is_pid(b), do: send(a, {:link, b})
  def crash(pid) when is_pid(pid), do: send(pid, :crash)

  defp loop do
    receive do
      :crash -> raise "Oh no, I have crashed!"
      {:link, pid} when is_pid(pid) -> Process.link(pid)
    end

    loop()
  end
end

a = Linkable.start()
b = Linkable.start()
c = Linkable.start()
d = Linkable.start()

Linkable.link(a, b)
Linkable.link(b, c)
Linkable.link(c, d)
Linkable.link(d, a)

Process.alive?(a)
Process.alive?(b)
Process.alive?(c)
Process.alive?(d)

Process.monitor(a)
Process.monitor(b)
Process.monitor(c)
Process.monitor(d)

Linkable.crash(a)
# Linkable.crash(b)
# Linkable.crash(c)
# Linkable.crash(d)

Process.alive?(a)
Process.alive?(b)
Process.alive?(c)
Process.alive?(d)
