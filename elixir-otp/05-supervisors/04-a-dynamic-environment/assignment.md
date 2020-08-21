# Assignment

Thanks to the beautiful design of this work environment, the minimal work loss with accidents and the immediate replacement of employees, our boss has decided to expand his company. Now he wants dynamically add workers to the company.

Constraints:

* Use a [Dynamic Supervisor](https://hexdocs.pm/elixir/DynamicSupervisor.html) instead of a normal supervisor.

## Some notes about the dynamic supervisor

### Getting started

The normal supervisor needed to know how many children it would have when spinning up. The Dynamic Supervisor, as the name implies, is meant to dynamically add workers as needed. Therefore we first start the Dynamic Supervisor with:

```elixir
DynamicSupervisor.start_link [name: MyDynamicSupervisor, strategy: :one_for_one]
```

### IDs

You no longer have to worry about IDs. Just provide enough information so that the Dynamic Supervisor can start its child:

```elixir
spec = {Employee, [name: EmployeeName]}
DynamicSupervisor.start_child(MyDynamicSupervisor, spec)
```
