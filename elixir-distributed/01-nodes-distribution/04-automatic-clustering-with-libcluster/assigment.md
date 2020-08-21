# Task

Manually connecting your nodes is not something you can do in production. Hence there's a library that makes your life easier called libcluster. There's a video that explains how it more or less works [here](https://www.youtube.com/watch?time_continue=191&v=zQEgEnjuQsU). This is just an extra and not required for this exercise.

First make an empty mix project (with an application level supervisor):

```bash
mix new da_libcluster_test --sup
```

Add the dependency as described on [this page](https://hexdocs.pm/libcluster/readme.html).

Goal: make the exercise "03-calling-remote-genserver" again, but this time provide a supervision tree with a dynamic supervisor to support this.

* You have your application level supervisor (already generated).
* Copy the `MyBuilding` module to your `lib` folder and refactor it to `DaLibclusterTest.Mybuilding`. Also refactor it so that it uses `start_link`, as we'll use it under a supervisor.
* Configure your application level supervisor for libcluster. You can either use the Epmd strategy (manual node config) or the gossip strategy. If you want to use the gossip strategy, use the following code in your application level supervisor:

```elixir
topologies = [
      da_assignment_test: [
        strategy: Cluster.Strategy.Gossip,
      ]
    ]
    children = [
      {Cluster.Supervisor, [topologies, [name: DaLibclusterTest.ClusterSupervisor]]},
    ]
```

* Let your application level supervisor start a dynamic supervisor with the name `DaLibclusterTest.BuildingDynamicSupervisor`.
* There is a module called `DaLibclusterTest`. Add the following methods:
  * To add childs easily: `DaLibclusterTest.start_building/1` where the argument is the name of the building, such as ProximusBlokD.
  * To check whether a node is running the process for a specific building: `DaLibclusterTest.building_at_this_node?/1` where the argument is a building atom.
  * To retrieve the rooms for a building at a specific node: `DaLibclusterTest.get_rooms_for_building_at_node/2` where the first parameter is your building name and the second your node name.
