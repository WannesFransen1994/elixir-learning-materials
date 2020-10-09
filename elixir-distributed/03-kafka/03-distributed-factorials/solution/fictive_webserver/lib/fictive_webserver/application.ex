defmodule FictiveWebserver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  @consumer_group "factorials_result_consumer_group"
  @topic "factorials-result"

  def start(_type, _args) do
    # using defaults
    consumer_group_opts = []
    gen_consumer_impl = FictiveWebserver.ResultConsumer
    topic_names = [@topic]

    children = [
      # Starts a worker by calling: FactorialWorker.Worker.start_link(arg)
      # {FactorialWorker.Worker, arg}
      {FictiveWebserver.FactorialResultWaiter, []},
      supervisor(
        KafkaEx.ConsumerGroup,
        [gen_consumer_impl, @consumer_group, topic_names, consumer_group_opts]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FictiveWebserver.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
