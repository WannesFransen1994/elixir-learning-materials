# Or you can use c "solution.ex" in your iex shell
Code.compile_file("solution.ex")

BuildingManager.start_link([])

result = BuildingManager.list_rooms()

IO.puts("\nThe following data was returned from \"list_rooms/0\"")
IO.inspect(result, label: SOLUTION_FILE)
