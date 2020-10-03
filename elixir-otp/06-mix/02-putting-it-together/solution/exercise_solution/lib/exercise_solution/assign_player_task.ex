defmodule ExerciseSolution.AssignPlayerTask do
  def run(arg) do
    instances = arg[:instances]
    strategy = arg[:strategy]
    p_pid = arg[:p_pid]
    p_name = arg[:p_name]

    instance = calculate_instance_to_assign_to(instances, strategy)
    # instance = calculate_instance_to_assign_to(state.instances, :random)
    # IO.inspect(instance, label: RESULT_INSTANCE)

    case Map.has_key?(instances, instance) do
      false -> {:error, :instance_does_not_exist}
      true -> ExerciseSolution.GameInstance.assign_player(instance, p_name, p_pid)
    end
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
