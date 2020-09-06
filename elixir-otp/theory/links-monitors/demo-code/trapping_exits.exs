Process.flag(:trap_exit, true)

# something crashes

flush
{:EXIT, PID, reason}
