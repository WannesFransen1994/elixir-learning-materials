# On node A
# start iex --werl --sname ping

# load this module by copy pasting it in your iex window
Node.ping(:"pong@wannes-Latitude-7490")
# Same as node.connect, returns pong when succesfull and pang if it didn't work out

defmodule PingPong do
  def start_link(), do: GenServer.start_link(__MODULE__, :ok)
  def init(:ok), do: {:ok, :empty_state}

  def handle_info({:ping, pid}, _) do
    :timer.sleep(1000)
    send(pid, {:pong, self()})
    {:noreply, :empty_state}
  end

  def handle_info({:pong, pid}, _) do
    :timer.sleep(1000)
    send(pid, {:ping, self()})
    {:noreply, :empty_state}
  end
end

{:ok, p1} = PingPong.start_link()
{:ok, p2} = PingPong.start_link()
:global.register_name({Node.self(), ProcessA}, p1)
:global.register_name({Node.self(), ProcessB}, p2)

# On node B
# start iex --werl --sname pong

:global.whereis_name(ProcessA)
# Returns undefined because you registered it as a tuple
pid = :global.registered_names() |> List.first() |> :global.whereis_name()
# Above code returns PID
send(pid, {:ping, self()})
flush()
