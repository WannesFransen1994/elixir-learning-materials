defmodule Demonstration do
  use GenServer
  @me __MODULE__

  def start_link(args \\ []), do: GenServer.start_link(@me, args, name: @me)

  def init(_args) do
    {:ok, :initial_state}
  end
end
