defmodule Example.MySupRoot do
  use Supervisor
  # ...
  def init(_init_arg) do
    children = [
      Example.MySubSup1,
      {Example.MyWorker, []},
      {Example.MyWorker, []}
