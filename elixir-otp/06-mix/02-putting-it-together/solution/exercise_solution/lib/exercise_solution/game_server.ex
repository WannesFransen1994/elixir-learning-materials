defmodule ExerciseSolution.GameServer do
  use GenServer

  require Logger

  @me __MODULE__

  defstruct instances: %{}

  def start_link(args), do: GenServer.start_link(@me, args, name: @me)

  def list_instances(), do: GenServer.call(@me, :list_instances)

  def assign_player_to_instance(player_name, player_pid),
    do: GenServer.call(@me, {:assign_player_to_instance, player_name, player_pid})

  def add_instance(instance), do: GenServer.cast(@me, {:add_instance, instance})

  def init(_args) do
    {:ok, %@me{}}
  end

  def handle_cast({:add_instance, instance}, state) do
    case ExerciseSolution.InstanceSupervisor.add_instance(name: instance) do
      {:ok, pid} ->
        new_instances = Map.put_new(state.instances, instance, %{pid: pid, players: 0})
        {:noreply, %{state | instances: new_instances}}

      {:error, reason} ->
        Logger.warn("Could not create instance because of #{inspect(reason)}")
        {:noreply, state}
    end
  end

  def handle_call(:list_instances, _from, state) do
    {:reply, state.instances, state}
  end

  def handle_call({:assign_player_to_instance, p_name, p_pid}, _from, %@me{} = state) do
    instance = calculate_instance_to_assign_to(state.instances)

    result =
      case Map.has_key?(state.instances, instance) do
        false -> {:error, :instance_does_not_exist}
        true -> ExerciseSolution.GameInstance.assign_player(instance, p_name, p_pid)
      end

    {:reply, result, state}
  end

  def handle_info({:report_player_load, pid, n_players}, %@me{} = state) do
    {name_instance, data} = find_instance_by_pid(state.instances, pid)

    updated_instance_data = %{data | players: n_players}
    updated_instances = %{state.instances | name_instance => updated_instance_data}

    {:noreply, %{state | instances: updated_instances}}
  end

  defp find_instance_by_pid(instances, instance_pid) do
    Enum.find(instances, nil, fn {_k, v} -> v.pid == instance_pid end)
  end

  defp calculate_instance_to_assign_to(instances) do
    {instance, _unnecessary_data} = Enum.random(instances)
    instance
  end
end
