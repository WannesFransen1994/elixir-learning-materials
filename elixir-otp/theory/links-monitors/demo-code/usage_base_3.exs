send(pid_A, {:echo, "Hello world", self})

# Output
# Echo from #PID<0.107.0>: Hello world

# Echo from #PID<0.174.0>: \
#   Echo from #PID<0.107.0>: Hello world

# Echo from #PID<0.176.0>: \
#   Echo from #PID<0.174.0>: \
#     Echo from #PID<0.107.0>: Hello world
