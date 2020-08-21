# From node pong:
Node.spawn(:"ping@wannes-Latitude-7490", fn ->
  IO.puts("Hello world on node: #{to_string(Node.self())}")
end)
