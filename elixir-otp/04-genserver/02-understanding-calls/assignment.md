# Assignment

As you just read, the previous solution wasn't decent code(if you have no idea what I'm talking about, check [the previous solution.ex file](../01-starting-the-genserver/solution.ex)). This exercise is quite simple, refactor your code so that it uses `GenServer.call` with the `handle_call` callback.

Working with `GenServer.call` is often referred to as a synchronous action. This is because of the caller process (e.g. our shell) is blocked until it gets a response or the timeout (3rd argument of `GenServer.call`) expires.

Refacter the function `list_rooms_manual_implementation/0` to `list_rooms/0`.
