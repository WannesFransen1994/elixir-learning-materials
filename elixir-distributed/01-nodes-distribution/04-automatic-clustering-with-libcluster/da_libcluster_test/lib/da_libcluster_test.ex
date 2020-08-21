defmodule DaLibclusterTest do
  def start_building(name) when is_atom(name) do
    DynamicSupervisor.start_child(
      DaLibclusterTest.BuildingDynamicSupervisor,
      {DaLibclusterTest.MyBuilding, name}
    )
  end

  def building_at_this_node?(building), do: building |> Process.whereis() |> Process.alive?()

  def get_rooms_for_building_at_node(building, node),
    do: GenServer.call({building, node}, :rooms_for_building)
end
