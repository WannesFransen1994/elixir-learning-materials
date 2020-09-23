defmodule ExerciseSolution.InstanceSupervisor do
  use DynamicSupervisor

  @me __MODULE__

  def start_link(init_arg), do: DynamicSupervisor.start_link(@me, init_arg, name: @me)

  @impl true
  def init(_init_arg), do: DynamicSupervisor.init(strategy: :one_for_one)

  def add_instance(opts) do
    DynamicSupervisor.start_child(@me, {ExerciseSolution.GameInstance, opts})
  end
end
