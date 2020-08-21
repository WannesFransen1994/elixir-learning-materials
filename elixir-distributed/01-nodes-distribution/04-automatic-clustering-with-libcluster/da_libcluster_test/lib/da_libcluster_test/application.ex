defmodule DaLibclusterTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = [
      da_libcluster_test: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: DaLibclusterTest.ClusterSupervisor]]},
      {DynamicSupervisor,
       strategy: :one_for_one, name: DaLibclusterTest.BuildingDynamicSupervisor}
    ]

    opts = [strategy: :one_for_one, name: DaLibclusterTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
