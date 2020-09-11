defmodule Example.MySubSup1 do
  use Supervisor
  # ...
  def init(_init_arg) do
    children = [
      {Example.MyWorker, []},
      {Example.MyWorker, []}
