def thread_func do
  IO.puts("Runs in different process")
end

spawn(&thread_func/0)
