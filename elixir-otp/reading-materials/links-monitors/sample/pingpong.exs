defmodule PingPong do
  # Note: this is the most rudimentary spawn! Check this with "inspect &(spawn)/3"
  #     You normally never use this.
  def start(), do: spawn(__MODULE__, :loop, [])

  def loop() do
    receive do
      {:ping, from} ->
        IO.puts("ping")
        Process.send_after(from, {:pong, self()}, 1_000)

      {:pong, from} ->
        IO.puts("pong")
        Process.send_after(from, {:ping, self()}, 1_000)

      {:link, to} ->
        Process.link(to)
    end

    loop()
  end
end

# p1 = PingPong.start()
# p2 = PingPong.start()
# send(p1, {:link, p2})
# send(p1, {:ping, p2})
# Process.exit(p2, :kill)
# Process.alive?(p1)
# Process.alive?(p2)
