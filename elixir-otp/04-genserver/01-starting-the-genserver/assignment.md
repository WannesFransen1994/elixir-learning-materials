# Assignment

In order to get started with GenServer, we need to know what the utmost basics are. We'll make a simple process that manages the rooms in a building. Read the [GenServer reading materials](/elixir-otp/reading-materials/genserver/genserver.md) first.

## Task 1

Create a module `BuildingManager` that is a GenServer.

In order to pass this exercise, you need to be able to start the GenServer with __`BuildingManager.start_link/1`__. This process needs to be __name registered__ under the module name.

Save your file as an `[FILENAME].ex` file. Elixir treats both files (`.exs` and `.ex`) the same way, but this means that the file contains contents which are meant to be compiled, after which you can use the compiled module in your `.exs` script (and later on in your mix projects). After that, create a `student.exs` file in which you'll compile your `[FILENAME].ex` with `c/1` (abbreviation for compile) or `Code.compile_file`.

When compiling, expect a warning about `init/1` which will be default injected. That's the next task!

---

## Task 2

Now that you can start your BuildingManager, we'll first want to initialize the state. This is done in your `init/1` callback. We'll want this function to initialize our genserver before we start processing messages. Keep a simple state which is a map to keep track of the rooms (`%{rooms: []}`).

After we have initialized our process, we'll want to ask information about our process. Write a function __`BuildingManager.list_rooms_manual_implementation/0`__ which will use `send` and `receive` to obtain the information from the genserver process.

### Tip

Our GenServer no longer has a recurring loop function in which we can manually parse the messages sent with `send` and parsed with `receive`. Cause this is such a common pattern, or OTP behaviour, GenServer abstracts this with `handle_info/2`. The first parameter is the message on which you pattern match, where the second is your state which you returned in the `init` function (or modified in other callback functions).

### Constraints task 2

* Do NOT use `GenServer.call`.
* Do NOT use `self/0` in your script / shell, do use it in your module.
* Do NOT pass parameters in the `BuildingManager.list_rooms_manual_implementation/0` function.

---

## Task 3

Use `self/0` 2 times in the module. They need to print 2 different PID's, word it into a nice little story such as:

```text
#PID<0.95.0> Is asking for more information regarding the rooms.
#PID<0.106.0> sends his regards.
```

### Constraints task 3

* Do NOT use `self/0` in your script / shell, do use it in your module.

---

## Extra

Make sure you understand the solution. Read the section at the end! Understand the differences between code execution of the caller process and callback code execution of the genserver process.
