defmodule ExerciseSolution.GameServer do
  use GenServer

  require Logger
  require IEx

  @me __MODULE__

  defstruct instances: %{}, total_players: 0

  ## API

  def start_link(args), do: GenServer.start_link(@me, args, name: @me)

  def list_instances(), do: GenServer.call(@me, :list_instances)

  def assign_player_to_instance(player_name, player_pid),
    do: GenServer.call(@me, {:assign_player_to_instance, player_name, player_pid})

  def add_instance(instance), do: GenServer.cast(@me, {:add_instance, instance})

  ## Callbacks

  def init(_args) do
    {:ok, %@me{}}
  end

  def handle_cast({:add_instance, instance}, state) do
    case ExerciseSolution.InstanceSupervisor.add_instance(name: instance) do
      {:ok, pid} ->
        {:noreply, add_instance_to_state(state, instance, pid)}

      {:error, reason} ->
        Logger.warn("Could not create instance because of #{inspect(reason)}")
        {:noreply, state}
    end
  end

  def handle_call(:list_instances, _from, state) do
    {:reply, state.instances, state}
  end

  def handle_call({:assign_player_to_instance, p_name, p_pid}, _from, %@me{} = state) do
    instance = calculate_instance_to_assign_to(state.instances, :wrr)
    # instance = calculate_instance_to_assign_to(state.instances, :random)
    # IO.inspect(instance, label: RESULT_INSTANCE)

    result =
      case Map.has_key?(state.instances, instance) do
        false -> {:error, :instance_does_not_exist}
        true -> ExerciseSolution.GameInstance.assign_player(instance, p_name, p_pid)
      end

    {:reply, result, state}
  end

  def handle_info({:report_player_load, pid, n_players}, %@me{} = state) do
    updated_state =
      state
      |> update_instance_players(pid, n_players)
      |> update_total_players()
      |> update_instance_load_balance_percentage()

    {:noreply, updated_state}
  end

  # SubTask 8A
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    {instance, _data} = find_instance_by_pid(state.instances, pid)
    updated_state = %{state | instances: Map.delete(state.instances, instance)}
    {:noreply, updated_state}
  end

  # SubTask 8B
  def handle_info({:register, instance, pid}, state) do
    {:noreply, add_instance_to_state(state, instance, pid, false)}
  end

  ## Helper functions

  defp add_instance_to_state(state, instance, pid, monitor? \\ true) do
    new_instances =
      Map.put_new(state.instances, instance, %{pid: pid, players: 0, percentage: 100})

    if monitor?, do: Process.monitor(pid)
    %{state | instances: new_instances}
  end

  defp update_instance_load_balance_percentage(%{instances: is, total_players: 0} = state) do
    percentages = Enum.map(is, fn {k, _v} -> {k, 100} end) |> Enum.into(%{})
    helper_update_instance_percentages(state, percentages)
  end

  defp update_instance_load_balance_percentage(%{total_players: tot_players} = state) do
    temp_instances =
      Enum.map(state.instances, fn {k, v} ->
        case v.players do
          0 -> {k, 100}
          n -> {k, tot_players / n}
        end
      end)

    temp_sum = Enum.map(temp_instances, fn {_k, v} -> v end) |> Enum.sum()

    percentages =
      Enum.map(temp_instances, fn {k, v} -> {k, Float.round(v / temp_sum, 2)} end)
      |> Enum.into(%{})

    helper_update_instance_percentages(state, percentages)
  end

  defp helper_update_instance_percentages(state, percentages) when is_map(percentages) do
    new_instances =
      Enum.map(state.instances, fn {k, v} ->
        percentage = Map.fetch!(percentages, k)
        new_instance_data = Map.put(v, :percentage, percentage)
        {k, new_instance_data}
      end)
      |> Enum.into(%{})

    %{state | instances: new_instances}
  end

  defp update_total_players(state) do
    n_players_sum = Enum.map(state.instances, fn {_k, v} -> v.players end) |> Enum.sum()
    %{state | total_players: n_players_sum}
  end

  defp update_instance_players(state, pid, n_players) do
    {name_instance, data} = find_instance_by_pid(state.instances, pid)

    updated_instance_data = %{data | players: n_players}
    updated_instances = %{state.instances | name_instance => updated_instance_data}

    %{state | instances: updated_instances}
  end

  defp find_instance_by_pid(instances, instance_pid) do
    Enum.find(instances, nil, fn {_k, v} -> v.pid == instance_pid end)
  end

  # defp calculate_instance_to_assign_to(instances, :random) do
  #   {instance, _unnecessary_data} = Enum.random(instances)
  #   instance
  # end

  defp calculate_instance_to_assign_to(instances, :wrr) do
    reformatted =
      Enum.map(instances, fn {k, v} -> {k, v.percentage * 100} end)
      |> Enum.sort_by(&elem(&1, 1), &<=/2)

    # IO.inspect(reformatted, label: DATA)

    random_number =
      Enum.map(reformatted, fn {_k, v} -> v end) |> Enum.sum() |> trunc |> :rand.uniform()

    # IO.inspect(random_number, label: RANDOM_NUMBER)

    Enum.reduce_while(reformatted, random_number, fn {instance, percentage}, acc ->
      if acc <= percentage, do: {:halt, instance}, else: {:cont, acc - percentage}
    end)
  end
end
