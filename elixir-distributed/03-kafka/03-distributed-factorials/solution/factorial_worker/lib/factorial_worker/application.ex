defmodule FactorialWorker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  @consumer_group "default_consumer_group"
  @topic "factorials-to-be-calculated"

  def start(_type, _args) do
    # using defaults
    consumer_group_opts = []
    gen_consumer_impl = FactorialWorker.FactorialConsumer
    topic_names = [@topic]

    children = [
      # Starts a worker by calling: FactorialWorker.Worker.start_link(arg)
      # {FactorialWorker.Worker, arg}
      supervisor(
        KafkaEx.ConsumerGroup,
        [gen_consumer_impl, @consumer_group, topic_names, consumer_group_opts]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FactorialWorker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
