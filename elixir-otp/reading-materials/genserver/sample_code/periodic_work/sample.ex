defmodule Sensor do
  use GenServer
  @me __MODULE__

  # time in ms
  @interval 1000 * 10

  defstruct [:degrees]

  #############
  #    API    #
  #############

  def start_link(args \\ []),
    do: GenServer.start_link(@me, args, name: @me)

  def report_temperature(pid_or_name \\ @me),
    do: GenServer.call(pid_or_name, :report_temp)

  #############
  # CALLBACKS #
  #############

  def init(_args) do
    Process.send_after(self(), :measure, @interval)
    {:ok, %@me{}, {:continue, :measure}}
  end

  def handle_info(:measure, %@me{} = state) do
    Process.send_after(self(), :measure, @interval)
    {:noreply, state, {:continue, :measure}}
  end

  def handle_call(:report_temp, _from, %@me{} = state),
    do: {:reply, state.degrees, state}

  def handle_continue(:measure, %@me{} = state) do
    # Get a random temperature between -50 -> 50 degrees C
    random_number = :rand.uniform(100) - 50
    new_state = %{state | degrees: random_number}
    {:noreply, new_state}
  end
end
