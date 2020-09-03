# Adding some rooms

The previous exercises allowed us to view the buildings of the process. Though it is kind of useless if we can't add rooms.

## Task 1

Provide a function `BuildingManager.add_room/3` which takes the building PID / name, room name and # of people that fit in that room. When a room already exists, just overwrite it. There can be no duplicate rooms.

## Task 2

Provide a function `BuildingManager.delete_room/2` which takes the building PID / name and room name. After this function is complete, the process should have no records of the room.

## Task 3

Refactor `BuildingManager.list_rooms/0` to `BuildingManager.list_rooms/1` where the argument is the building PID / name.

## Constraints

Following constraints apply:

* Use `GenServer.cast` internally, the caller should not be aware that the BuildingManager is a `GenServer`.
* Use a struct to keep the state.
* There can be no duplicate rooms (e.g. rooms should be unique).
* The room name should either be an atom or a string.
* The amount of people should be a positive integer (hint: guard)
