# Assignment

Disregarding the cost of human lives, we don't want our explosives, or remaining work, to be lost. That's why we're going back to our first solution (sending `:boom` to a worker only results in that worker being replaced).

Though when an explosion occurs, the remaining work must be divided and assigned to the other 2 workers.

```text
    A  B  C => Normal workers
    A  X  C => B explodes, but had 10 remaining work
    A  B' C => B has 0 work. A and C have both received +5 work.
```

To achieve this, use the GenServer [terminate](https://hexdocs.pm/elixir/GenServer.html#c:terminate/2) callback.

_Note: when dividing the remaining work to N workers, don't worry about rounding mistakes. The point of this exercise is to use the terminate callback to divide the remaining work._
