# Task

Connect 2 iex shells together.

* Use the `--sname` option
* Verify your own node name with `Node.self/0`
* Use `Node.connect/1` or `Node.ping/1` to connect your nodes
* Verify that the nodes are connected with `Node.list/0`

**Extra** Elixir uses the Erlang epmd underneath. This is the daemon that allows your shells to communicate. Verify that this is running with `epmd -names` (after starting your named iex shells). If `epmd` does not exist, follow these [instructions](../windows-setup.md). You should see something like:

```bash
> $ epmd -names
epmd: up and running on port 4369 with data:
name ping at port 44441
name pong at port 35705
```
