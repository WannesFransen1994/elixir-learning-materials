# GenServer - periodic work with handle_info

It is often that an application needs to do periodic work. Or even better, maybe just one small subset of an application needs to do something every X seconds. Here we'll cover a very simple implementation of periodic work with handle_info.

## A simple use case

Imagine that in an IoT context, you've got a temperature (or/ and moisture/ humidity) sensor and you want it to report a warning when a value becomes too large / small. This all to protect your beautiful flowers or to make an optimal greenhouse.

In order to do this, we want a simple application that reports the values of the sensors every 5 minutes. How do we achieve this? Messages of course!

Let us create a simple sensor that does all of the above.

### Booting up our sensor

As we've seen already, we can use handle_continue to make sure that when our process starts, there's an initial temperature. Let's start with this:

```elixir
defmodule Sensor do
  use GenServer
  @me __MODULE__

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

  def init(_args), do: {:ok, %@me{}, {:continue, :measure}}

  def handle_call(:report_temp, _from, %@me{} = state),
    do: {:reply, state.degrees, state}

  def handle_continue(:measure, %@me{} = state) do
    # Get a random temperature between -50 -> 50 degrees C
    random_number = :rand.uniform(100) - 50
    new_state = %{state | degrees: random_number}
    {:noreply, new_state}
  end
end
```

Most of this should already be familiar. We can start the process with `start_link/1`, which will start the process and let it invoke the `init/1` callback. This will set the state to a struct of the `Sensor` module. Before we answer any messages, we enforce measuring the temperature with `handle_continue/2`. This function will generate a random temperature between -50 and 50 degrees Celcius. After that, people can ask the sensor to report its temperature.

Wonderful! Throw it in you iex shell and play with it. It should return something like:

```elixir
iex> Sensor.start_link
{:ok, #PID<0.140.0>}
iex> Sensor.report_temperature
-7
iex> Sensor.report_temperature
-7
```

Which is great, though there's one small issue. We only measure the temperature when it boots. Let us fix that with sending a message in our `init` function and providing a `handle_info` callback. For now, let us measure every 10 seconds.

```elixir
  # time in ms
  @interval 1000 * 10

  def init(_args) do
    Process.send_after(self(), :measure, @interval)
    {:ok, %@me{}, {:continue, :measure}}
  end

  def handle_info(:measure, %@me{} = state) do
    Process.send_after(self(), :measure, @interval)
    {:noreply, state, {:continue, :measure}}
  end
```

Which will result in something like:

```elixir
iex> Sensor.report_temperature
35
iex> Sensor.report_temperature
-4
iex> Sensor.report_temperature
-30
```

So what happened here? In our `init` callback we send a message after 10 seconds to ourself. This message causes the `handle_info` callback to activate, which activates the measure `handle_continue` callback. This way we can reuse our measure code.

_Please do note that there are other ways to implement this as well, but we've chosen for this approach to explicitly illustrate that `handle_continue` isn't only called after the init, but can also be called after other callbacks._

Good job! This was a really short topic, but now you can make simple periodic work happen. For more complex use cases, it can be interesting to look at libraries specialised in this (e.g. [Oban](https://hex.pm/packages/oban)).
