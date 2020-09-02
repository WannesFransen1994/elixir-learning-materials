defmodule Demonstration do
  use GenServer
  @me __MODULE__

  def start_link(args \\ []), do: GenServer.start_link(@me, args, name: @me)

  def init(_args) do
    :timer.sleep(10_000)
    {:ok, :initial_state}
  end
end
