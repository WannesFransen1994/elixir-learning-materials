defmodule LibraryProcess do
  use GenServer

  @default_books [
    "I love little ponies",
    "Next to the mountain is a rainbow",
    "Look at this little bear"
  ]

  def start(args \\ []) do
    GenServer.start(__MODULE__, args, name: __MODULE__)
  end

  # With this function we'll request the books from the library process.
  def request_books(pid_or_name) do
    GenServer.call(pid_or_name, :request_books)
  end

  def add_book(pid_or_name, book) do
    GenServer.cast(pid_or_name, {:add_book, book})
  end

  def stop(pid_or_name), do: GenServer.stop(pid_or_name)

  #############
  # CALLBACKS #
  #############

  def init(_args) do
    initial_state = %{books: @default_books}
    {:ok, initial_state}
  end

  def handle_call(:request_books, {_from_pid, _from_reference} = _from, state) do
    {:reply, state.books, state}
  end

  def handle_cast({:add_book, book}, state) do
    new_book_list = [book | state.books]
    new_state = %{state | books: new_book_list}
    {:noreply, new_state}
  end

  def terminate(reason, state) do
    IO.puts("We stop because of reason #{reason}. Our final state is:")
    IO.inspect(state)
    :this_return_value_is_ignored
  end
end
