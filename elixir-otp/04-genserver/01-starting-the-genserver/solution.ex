##########
# Task 1 #
##########
# Ignore the 1 and 2 and the end of the module name.
#   This is so that when you copy paste, there are no compilation errors
defmodule BuildingManager1 do
  use GenServer

  def start_link(args) do
    # Note: for now we will not worry about the state.
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end
end

##########
# Task 2 #
##########
defmodule BuildingManager2 do
  use GenServer

  #######
  # API #
  #######

  def start_link(args) do
    # Note: for now we will not worry about the state.
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def list_rooms_manual_implementation() do
    send(__MODULE__, {:send_rooms_info_to, self()})
    IO.puts("\n#{inspect(self())} Is asking for more information regarding the rooms.")

    # In Elixir, every function returns something. Here you can see that the receive funtion will
    #   return the bound information data. This will become the output of this function.
    receive do
      {:rooms_info, information} -> information
    end
  end

  ############
  # Callback #
  ############

  def init(args) do
    IO.puts("\n\nWe received the following args and are completely ignoring these:")
    IO.inspect(args, label: __MODULE__.INIT)

    initial_state = %{rooms: []}
    {:ok, initial_state}
  end

  def handle_info({:send_rooms_info_to, caller}, state) do
    send(caller, {:rooms_info, {state.rooms, :cheers_from, self()}})
    {:noreply, state}
  end
end

#####################
# Extra information #
#####################

# 1. When you execute code under the API section, this code is executed as the caller process.
#      Elixir devs will often split this into the callback sections (thats what the GenServer)
#      module abstracts for you, and the API section is the "interface".

# 2. There are still some issues with our code. E.g. we do not know whether the answer from our
#      GenServer is associated with our request. In order to make it more secure, we could pass a
#      ref with our request, which is used to identify our response. Though this is out of scope
#      for this assignment

# 3. The send and receive applications in this exercise are ONLY for educational purposes. In the
#      next exercise, we'll replace this code. Please never write code like this for production apps.
