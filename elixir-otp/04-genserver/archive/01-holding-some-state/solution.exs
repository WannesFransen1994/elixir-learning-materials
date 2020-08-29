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

  def handle_call(:rooms_for_building, _from, s), do: {:reply, s, s}
end

MyBuilding.start(ProximusBlockD)
MyBuilding.get_rooms_for_building(ProximusBlockD)
# or
MyBuilding.start(ProximusBlockD, rooms: [d1: %{capacity: 1}])
MyBuilding.get_rooms_for_building(ProximusBlockD)
