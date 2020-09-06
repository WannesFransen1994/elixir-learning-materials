receive do
  # ...

  {:monitor, to} ->
    Process.monitor(to)
    loop(to)

  random_msg ->
    IO.puts("Random message:")
    IO.inspect(random_msg)
    loop(next)
end
