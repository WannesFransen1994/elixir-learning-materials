defmodule Example.MySupervisor do
  use Supervisor
  @me __MODULE__

  def start_link(arg) do
    Supervisor.start_link(@me, arg)
  end

  def init(_init_arg) do
    children = [
      {Example.MyWorker, []}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end
end
