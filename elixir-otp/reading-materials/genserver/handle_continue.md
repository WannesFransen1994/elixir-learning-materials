# GenServer - `handle_continue` since Elixir v1.7

Now that you know what the basics of a GenServer are and why an init is blocking, we're going to delve a bit deeper. Don't worry, this time there won't be Erlang code.

Since [Elixir v1.7](https://github.com/elixir-lang/elixir/releases/tag/v1.7.0) there's support for an additional `handle_continue` callback. Which is arguably one of the nicest features in order to initialize a GenServer without blocking the caller.

## Before `handle_continue`

First we'll look at an example how we can naively implement this without `handle_continue` and what the issues are. Let's take a simple example with a blocking init call:

```elixir
defmodule Demonstration do
  use GenServer
  @me __MODULE__

  def start_link(args \\ []), do: GenServer.start_link(@me, args, name: @me)

  def init(_args) do
    :timer.sleep(10_000)
    {:ok, :initial_state}
  end
end
```

We've already seen that this is not ideal. We know that in the background there's a loop function which processes messages, so what if we'd immediately send a message to ourselves so that it is the first message in the mailbox? This way we can initialize the state first thing after the `init/1` callback. The code would look like the following:

```elixir
  def init(_args) do
    send(self(), :initialize_state)
    {:ok, :not_initialized_state}
  end

  def handle_info(:initialize_state, :not_initialized_state) do
    # Perform a long computation to initialize state
    :timer.sleep(10_000)
    {:noreply, :initialized_state}
  end
```

Here we can see that the first thing we do is send a message, we __assume__ that the first message in the mailbox will be this message and initializes the state.

_Extra info: In the chapter regarding blocking init, we've seen where the name registration occurs. This means that we can receive messages BEFORE the init is finished. When the init callback is called, the process is already name registered._

The above process is name registered under the module name. Let us create a module whose sole purpose is to send `:some_message` to the `Demonstration` process.

```elixir
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
```

The above module will just spam messages when the `Demonstration` process is alive. In order to process these, we'll add the following callbacks to our `Demonstration` module:

```elixir
  def handle_info(:some_message, :initialized_state) do
    IO.puts("Correctly processed message. Shutting down.")
    {:stop, :shutdown, :initialized_state}
  end

  def handle_info(:some_message, _unsupported_state) do
    raise "Oh no! We got a message while our state wasn't initialized!"
  end
```

This code is really simple. If the state is initialized already, then we'll just silently shut down. But if we get a message while the state isn't initialized yet, it'll raise errors and crash. Now let us look at 2 use cases:

### First the Demonstration process, then the Spammer

Let us look at what happens when we first start the demonstration process and after that the spammer process.

```elixir
# compile both modules in your iex shell
iex> Demonstration.start_link()
{:ok, #PID<0.157.0>}
iex> Spammer.start_link()
#PID<0.159.0>
Correctly processed message. Shutting down.
** (EXIT from #PID<0.107.0>) shell process exited with reason: shutdown
```

This is the normal behaviour. The `Demonstration` process receives a message while initialized and shuts down normally. Though it often happens that this isn't the case when other processes are alive. Thus the use case where the spammer is already alive is more probably in highly concurrent applications.

### First the Spammer, then the Demonstration process

Now we'll look at the use case of a highly concurrent system where a lot of messages are sent (to e.g. a name registered process). We'll use the exact same code as the last use case, only start the spammer first:

```elixir
iex> Spammer.start_link()
#PID<0.165.0>
iex> Demonstration.start_link()
{:ok, #PID<0.167.0>}
iex>
12:27:49.278 [error] GenServer Demonstration terminating
** (RuntimeError) Oh no! We got a message while our state wasn't initialized!
    iex:24: Demonstration.handle_info/2
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4
    (stdlib 3.13) gen_server.erl:756: :gen_server.handle_msg/6
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: :some_message
State: :not_initialized_state
** (EXIT from #PID<0.163.0>) shell process exited with reason: an exception was raised:
    ** (RuntimeError) Oh no! We got a message while our state wasn't initialized!
        iex:24: Demonstration.handle_info/2
        (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4
        (stdlib 3.13) gen_server.erl:756: :gen_server.handle_msg/6
        (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
```

As you can see, our `Demonstration` process crashed due to a not initialized state! We could program our way around it with a lot of function clauses for each callback (in case our state isn't initialized), but the `handle_continue` callback came to the rescue.

## Handle continue to the rescue

The `handle_continue` callback guarantees that before you start your loop in order to process messages, it'll execute this callback first.

_Note: this doesn't necessarily need to be in your `init` callback. It is also possible to call `handle_continue` from other callbacks!_

Let us refacter our `Demonstration` module:

```elixir
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
```

Now, no matter how many spammers there are, you won't have the issue anymore of having a not-initialized process and still don't have to block our caller!

In order to illustrate this, imagine a lot of spammers:

_Note: Put a short sleep in there to make sure that all processed are ready to spam!_

```elixir
iex> Spammer.start_link()
#PID<0.157.0>
iex> Spammer.start_link()
#PID<0.159.0>
iex> Spammer.start_link()
#PID<0.161.0>
iex> Spammer.start_link()
#PID<0.163.0>
iex> :timer.sleep(100)
:ok
iex> Demonstration.start_link()
{:ok, #PID<0.166.0>}
Correctly processed message. Shutting down.
** (EXIT from #PID<0.107.0>) shell process exited with reason: shutdown
```

Try it as often as you want to, but the process will shut down correctly. Now that we know the joy of the `handle_continue` callback, we can write even better OTP applications! Happy coding!
