def init(_init_arg) do
  children = [
    {MyModule, [:arg_one, :arg_two]}
  ]
