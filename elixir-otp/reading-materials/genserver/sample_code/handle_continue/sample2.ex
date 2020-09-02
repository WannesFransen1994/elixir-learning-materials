defmodule Demonstration do
  use GenServer
  @me __MODULE__

  def start_link(args \\ []), do: GenServer.start_link(@me, args, name: @me)

  def init(_args) do
    send(self(), :initialize_state)
    {:ok, :not_initialized_state, {:continue, :initialize_state}}
  end

  def handle_continue(:initialize_state, :not_initialized_state) do
    # Perform a long computation to initialize state
    :timer.sleep(10_000)
    {:noreply, :initialized_state}
  end

  def handle_info(:some_message, :initialized_state) do
    IO.puts("Correctly processed message. Shutting down.")
    {:stop, :shutdown, :initialized_state}
  end

  def handle_info(:some_message, _unsupported_state) do
    raise "Oh no! We got a message while our state wasn't initialized!"
  end
end

defmodule Spammer do
  def start_link(_args \\ []) do
    spawn_link(__MODULE__, :spam, [])
  end

  def spam() do
    case Process.whereis(Demonstration) do
      nil -> nil
      pid -> send(pid, :some_message)
    end

    spam()
  end
end

Spammer.start_link()
Spammer.start_link()
Spammer.start_link()
Spammer.start_link()
:timer.sleep(100)
Demonstration.start_link()
