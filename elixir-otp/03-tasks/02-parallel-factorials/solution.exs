defmodule Factorial do
  def calc(n), do: calc(n, 1)
  defp calc(1, acc), do: acc
  defp calc(n, acc), do: calc(n - 1, acc * n)

  def benchmark(f) do
    t1 = DateTime.utc_now()
    f.()
    t2 = DateTime.utc_now()
    DateTime.diff(t2, t1, :millisecond)
  end
end

n = 2_000

t1 = Factorial.benchmark(fn ->
  Enum.map(1..n, &Factorial.calc(&1))
end)

IO.puts("Sequential: #{t1}ms")

t2 = Factorial.benchmark(fn ->
  tasks = Enum.map(
    1..n,
    fn k -> Task.async(fn -> Factorial.calc(k) end) end
  )

  Task.yield_many(tasks, :infinity)
end)

IO.puts("Parallelized: #{t2}ms")
