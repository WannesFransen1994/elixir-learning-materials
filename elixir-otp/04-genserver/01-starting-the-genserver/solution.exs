# Or you can use c "solution.ex" in your iex shell
Code.compile_file("solution.ex")

BuildingManager2.start_link([])

{result, :cheers_from, genserver_pid} = BuildingManager2.list_rooms_manual_implementation()

IO.puts("#{inspect(genserver_pid)} sends his regards.")

IO.puts("\nThe following data was returned from \"list_rooms_manual_implementation/0\"")
IO.inspect(result, label: SOLUTION_FILE)
