defmodule PingPong do
  use GenServer
  def start_link(_ \\ []), do: GenServer.start_link(__MODULE__, :ok)
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
