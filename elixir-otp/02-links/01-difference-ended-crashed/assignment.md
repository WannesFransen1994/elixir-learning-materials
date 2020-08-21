# Assignment

In the previous series of exercises, you've spawned several processes. Now we're going to see what linking processes means.

Perform the following tasks:

* Start a process with a normal exit value. Make sure that the exit value is returned __after__ you've `link`ed the process.
* Start a process that `raise`s an error. Like the previous process, link it to your `iex` shell and let them both crash. Verify that your shell is a new PID with `self()`.

 After completing this exercise with only `spawn/1` and `Process.link/1`, try completing this exercise with `spawn_link/1`.
