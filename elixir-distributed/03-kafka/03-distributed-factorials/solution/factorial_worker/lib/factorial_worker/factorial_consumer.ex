defmodule FactorialWorker.FactorialConsumer do
  use KafkaEx.GenConsumer
  require Logger
  require IEx

  alias KafkaEx.Protocol.Fetch.Message
  alias KafkaEx.Protocol.Produce.Request
  # alias KafkaEx.Protocol.Produce.Message

  @topic "factorials-result"
  @default_req %Request{
    topic: @topic,
    required_acks: 1
  }

  # note - messages are delivered in batches
  def handle_message_set(message_set, state) do
    # Logger.debug(fn -> "#{inspect(self())}/message: " <> inspect(message_set) end)

    for %Message{value: message} <- message_set do
      {parsed, _remainder} = Integer.parse(message)
      result = factorial(parsed)

      send_result = send_result(message, result)
      IO.inspect(send_result)
    end

    {:async_commit, state}
  end

  defp send_result(request, result) do
    message = %KafkaEx.Protocol.Produce.Message{value: "#{request};#{result}"}
    request = %{@default_req | messages: [message]}

    KafkaEx.produce(request)
  end

  defp factorial(0), do: 1
  defp factorial(n) when is_number(n) and n > 0, do: n * factorial(n - 1)
end
