# Assignment

GenServers. Now the fun begins!

At the end of these exercises, we're going to have a tracking application for people in a building (of course, this is just a fictional exercise and by no means would we dare to violate privacy rights).

Create a GenServer `MyBuilding` whose instances model buildings. It should keep track of all rooms alongside their properties, such as their capacity. Store the data as a struct.
For example, the building data could be the following:

```elixir
%MyBuilding{ rooms: [ d210: %{ capacity: 50, projector: true  },
                      d220: %{ capacity: 50, projector: true  },
                      d224: %{ capacity: 6 , projector: false } ] }
```

When initializing the GenServer, use this data if the client fails to provide building data of his own:

```elixir
iex(1)> MyBuilding.start(ProximusBlockD) # Uses default data

iex(2)> MyBuilding.get_rooms_for_building(ProximusBlockD)
%MyBuilding{ rooms: [ d210: %{ capacity: 50, projector: true  },
                      d220: %{ capacity: 50, projector: true  },
                      d224: %{ capacity: 6 , projector: false } ] }

iex(3)> MyBuilding.start(ProximusBlockC, rooms: [ d1: %{capacity: 1} ])
```

The GenServer should [name registered](https://www.amberbit.com/blog/2016/5/13/process-name-registration-in-elixir/) with the name of the building.
