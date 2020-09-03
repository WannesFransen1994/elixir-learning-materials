# Backup & autorestore functionality

Now that we can manage our buildings, it is time to add some kind of backup functionality. Imagine having hundreds of rooms, you don't want to insert that manually every time right?

## Task 1

The `BuildingManager` process will take a backup every 10 seconds, which will be stored in csv format and look like:

```csv
d224,atom,6
d223,string,4
d222,atom,6
d221,atom,2
d225,atom,8
```

The 1st column is the name, but this could be either a string or an atom. That's why in the 2nd column we specify the type as well. The 3rd column is the amount of people that fit into that room.

For the filename, feel free to hardcode this. Normally this is something you put in the application config, but we're not covering that yet.

## Task 2

Upon starting the `BuildingManager`, it'll restore its rooms. By no means should the `BuildingManager` be able to process messages while its state isn't correct yet!!! It is not allowed to do this in the `init` function.
