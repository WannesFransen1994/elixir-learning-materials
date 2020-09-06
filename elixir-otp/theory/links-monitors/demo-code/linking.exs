# As process A
ProcessB
|> Process.whereis()
|> Process.link()

# As process B
ProcessC
|> Process.whereis()
|> Process.link()
