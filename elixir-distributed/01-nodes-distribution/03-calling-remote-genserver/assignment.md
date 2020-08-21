# Task

We're reusing the following code from the GenServer assignment:

```elixir
defmodule MyBuilding do
  use GenServer

  @d210 %{capacity: 50, projector: true}
  @d220 %{capacity: 50, projector: true}
  @d224 %{capacity: 6, projector: false}

  @default_rooms [d210: @d210, d220: @d220, d224: @d224]

  defstruct rooms: @default_rooms

  def start(name, args \\ []), do: GenServer.start(__MODULE__, args, name: name)
  def init(args), do: {:ok, struct(__MODULE__, args)}

  def get_rooms_for_building(building) when is_atom(building),
    do: GenServer.call(building, :rooms_for_building)

  def add_room(building, room, capacity)
      when is_atom(building) and is_atom(room) and is_integer(capacity),
      do: GenServer.cast(building, {:add_room, room, capacity})

  def handle_call(:rooms_for_building, _from, s), do: {:reply, s, s}

  def handle_cast({:add_room, room, capacity}, %{rooms: rs} = s),
    do: {:noreply, %{s | rooms: [{room, %{capacity: capacity}} | rs]}}
end

MyBuilding.start(ProximusBlokD)
```

Execute this code at node B. Verify that your GenServer is running with `Process.whereis/1` at node B.

When you perform the same verification at node A with `Process.whereis/1`, you shouldn't be able to find the GenServer on your node.

Goal of this exercise:
Retrieve the rooms for the ProximusBlokD building on node A (the node where the process is NOT running). Use the familiar `GenServer.call`.
