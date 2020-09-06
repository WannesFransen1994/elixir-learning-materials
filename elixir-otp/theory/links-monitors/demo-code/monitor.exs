# Process A
ProcessB
|> Process.whereis()
|> Process.monitor()

# Process B
ProcessC
|> Process.whereis()
|> Process.monitor()
