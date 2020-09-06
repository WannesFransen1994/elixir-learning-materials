send(pid_A, {:update_next, pid_B})
send(pid_B, {:update_next, pid_C})
