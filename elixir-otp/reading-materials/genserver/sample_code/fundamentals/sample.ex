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
