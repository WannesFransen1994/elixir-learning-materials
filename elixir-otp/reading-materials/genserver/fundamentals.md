# GenServer

A GenServer stands for generic server (process). A more generalized description would be that the GenServer behaviour implements certain functions (and callbacks) so that you can focus on the business logic and don't have to do manual message processing and so on.

## Basic processes

First, let us take look at how some basic code would look like with a normal process.

Below you can find a process that only needs to hold some state and do stateful operations. E.g. add a book, delete a book, and so on. It is a lot of code, but we'll go over it step by step.

```elixir
defmodule LibraryProcess do
  # A subtle reminder how module attributes are used.
  @default_books [
    "I love little ponies",
    "Next to the mountain is a rainbow",
    "Look at this little bear"
  ]

  #######
  # API #
  #######

  # A start function to start this process. For simplicity's sake, we'll
  #   name register the process under its own module name.
  def start(args \\ []) do
    pid = spawn(LibraryProcess, :init, [args])
    Process.register(pid, __MODULE__)
    pid
  end

  # With this function we'll request the books from the library process.
  def request_books(pid_or_name) do
    reference = make_ref()
    send(pid_or_name, {:get_all_books, self(), reference})

    receive do
      {:response_books, books, ^reference} -> books
    after
      1000 -> {:error, "No answer given within the provided time."}
    end
  end

  # Add a book by name
  def add_book(pid_or_name, book) do
    send(pid_or_name, {:add_book, book})
  end

  # Stop the process
  def stop(pid_or_name) do
    send(pid_or_name, {:stop, :shutdown})
  end

  #############
  # CALLBACKS #
  #############

  # Init will do the initial state configuration.
  #   In our case, this'll be to keep track of the books.
  def init(_args) do
    initial_state = %{books: @default_books}
    loop(initial_state)
  end

  # This will be the main recurring loop that'll listen to messages and process them.
  defp loop(state) do
    receive do
      {:get_all_books, pid, reference} ->
        send(pid, {:response_books, state.books, reference})
        loop(state)

      {:add_book, book} ->
        loop(%{books: [book | state.books]})

      {:stop, reason} ->
        terminate(reason, state)
    end
  end

  defp terminate(reason, state) do
    IO.puts("We stop because of reason #{reason}. Our final state is:")
    IO.inspect(state)
    :this_return_value_is_ignored
  end
end
```

### Code organization. API vs callbacks

For now, let's skip over function implementations and just looks at the functions. A minimal version would be something like:

```elixir
defmodule LibraryProcess do
  #######
  # API #
  #######
  def start(args \\ [])
  def request_books(pid_or_name)
  def add_book(pid_or_name, book)
  def stop(pid_or_name)

  #############
  # CALLBACKS #
  #############
  def init(_args)
  defp loop(state)
  defp terminate(reason, state)
end
```

If we'd skim over this, we can immediately see what functions are meant to abstract some functionality. The API functions will abstract how the server actually works. For example, it could be either a raw process or an actual GenServer. You don't want to program this in other processes, as they don't need to know this. Refactoring would become annoying as well.

The callbacks section is the code that the running process will execute. Those callbacks, or functions, will be executed by the library process. __NOT the caller process!__

To clarify, functions under the API section will be executed by the caller, e.g. our shell. This will send messages towards our library process, which is executing code to receive those messages (the receive in the loop function). That code is processed and will send a message back towards the caller with the response (if applicable). The caller will process the message and in the meanwhile the library process is already waiting for the next message.

### Process initialization

Let's put the focus on the following code:

```elixir
defmodule LibraryProcess do
  def start(args \\ []) do
    pid = spawn(LibraryProcess, :init, [args])
    Process.register(pid, __MODULE__)
    pid
  end

  def init(_args) do
    initial_state = %{books: @default_books}
    loop(initial_state)
  end

  defp loop(state) do
    # ...
  end
end
```

The above code is mostly related with the initialization of the process. We can mostly categorize these steps as the following:

```text
Module.start => spawn process => possible name registration => initialize state with init/1
```

Above steps are rather common. Not to mention that a lot more things happen on the background, which is for now not important. Since the GenServer module abstracts this for us, it'll look like the following:

```elixir
defmodule LibraryProcess do
  use GenServer

  def start(args \\ []) do
    GenServer.start(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    initial_state = %{books: @default_books}
    {:ok, initial_state}
  end
end
```

With these few lines of code, we can start our process and it's ready to go! Few things to note:

* No longer any need to manually register your process. This is done automatically thanks to the `name: [NAME]` options.
* In the background, Erlang its `:gen_server` is called.
* After that, the init callback is called upon. Just like our old code.
* This callback expects to return a specific tuple. Since this has to do with complicated topics such as hibernation, supervisors, handle_continue callback, we'll skip this for now and just assume that the {:ok, initial_state} tuple is good for now.

### Stopping the process

Copy pasting the terminate functionality was also rather cumbersome when you have a lot of similar processes. That's also a lot easier with GenServer.

```elixir
defmodule LibraryProcess do
  def stop(pid_or_name), do: GenServer.stop(pid_or_name)
  def terminate(reason, state) do
    IO.puts("We stop because of reason #{reason}. Our final state is:")
    IO.inspect(state)
    :this_return_value_is_ignored
  end
end
```

This code looks almost the same, except the need to manually parse messages in our receive loop. The purpose of the terminate callback is the opposite of our init, to clean up our process.

Do note that the terminate callback is not called upon every time the processes exits. There are certain requirements to be met. You can, for now, assume that with a normal shutdown behaviour the GenServer will call upon its terminate callback.

### `Genserver.cast` and `handle_cast/2`

Next up, we will take a look at asynchronous operations. Examples of these are sending normal messages and using the `GenServer.cast` function. You send a message and don't expect a reply. Let's rewrite our `add_book/1` function.

```elixir
defmodule LibraryProcess do
  use GenServer
  
  def add_book(pid_or_name, book) do
    GenServer.cast(pid_or_name, {:add_book, book})
  end

  def handle_cast({:add_book, book}, state) do
    new_book_list = [book | state.books]
    new_state = %{state | books: new_book_list}
    {:noreply, new_state}
  end
end
```

In the above code there was no need to return information towards the user. Hence `GenServer.cast` was a viable option. When performing a cast, you'll need to provide an associated `handle_cast` callback.

The state is updated in the callback, after which we update this with the expected return tuple format. The :noreply atom in the tuple tells our GenServer that it doesn't need to send a reply to another process.

_Most of the time a `handle_cast` or `handle_info` doesn't need to give a reply. Though there are use cases where this is applicable, but we'll cover that in our advanced section._

### The `handle_info/2` callback

Similar to the previous section, there's also the `handle_info/2` callback. This is when a normal message arrives which is not sent by the GenServer API (e.g. `GenServer.cast` or `GenServer.call`). The callback usage is completely the same as `GenServer.cast`.

The difference lies mostly in the usage. If you're going to call your module API, then most likely a GenServer.cast will be used, because that can be easily abstracted. On the other hand, if you do periodic work for example, you will most likely be receiving normal messages instead of cast messages. In such cases, it is likely that you'll use `handle_info`. We'll use this extensively in the more advanced sections.

### `GenServer.call` and `handle_call/3`

This might as well be one of the nicest abstractions of the GenServer module. Let's quickly review the old code:

```elixir
# ...
  def request_books(pid_or_name) do
    reference = make_ref()
    send(pid_or_name, {:get_all_books, self(), reference})

    receive do
      {:response_books, books, ^reference} -> books
    after
      1000 -> {:error, "No answer given within the provided time."}
    end
  end

# ...
  defp loop(state) do
    receive do
      {:get_all_books, pid, reference} ->
        send(pid, {:response_books, state.books, reference})
# ...
```

A lot is happening here. We see that we first make a reference, this to uniquely identify our request, after which we send a message to our library process. Do note that at this point in time, you don't wait until the library process replies whatsoever, you just send a message and execute the next lines of code, which in this case is the receive statement.

You wait until you get a response. In the meanwhile, the message with the unique identifier was sent towards your library process. It receives the message, sends an answer with the same identifier (basically you're saying "Hey this response belongs to that request!") and wait for the next message.

When the caller, which is waiting for a message with the same identifier (that's the pin operator there), recieves the message it'll return the books variable that was in the message. There we go. Phew, that's a lot for a simple functionality isn't it? Let's see how we can do this with a GenServer:

```elixir
# ...
  def request_books(pid_or_name) do
    GenServer.call(pid_or_name, :request_books)
  end
# ...
  def handle_call(:request_books, {_from_pid, _from_reference} = _from, state) do
    {:reply, state.books, state}
  end
```

All that complicated logic is abstracted behind `GenServer.call`. You can also see the `handle_call/3` callback which will be called upon. As you can see, the `_from` tuple contains the caller PID with a reference, this way it can safely send a response.

Here we use the reply tuple. It is possible to not send a reply immediately, but this is for more complex use cases. For now you can naively assume that when called upon, one shall reply.

## Extra materials

This is just to understand the fundamentals of a GenServer, which most often of the time should suffice. Though more complex use cases will appear. Here are some extra reading materials to boost your GenServer skills:

* [`handle_continue` since Elixir v1.6 & why init is blocking \[TODO\]](./handle_continue.md)
* [periodic work with handle_info \[TODO\]](./periodic_work.md)
* [non-immediate replies with tasks \[TODO\]](./non-immediate_replies.md) _Note: you need to understand supervisors and tasks._
* [How you get a GenServer that uses huge amounts of RAM without hibernate \[TODO\]](./hibernate.md)
