defmodule FictiveWebserver.ResultConsumer do
  use KafkaEx.GenConsumer
  require Logger
  require IEx

  alias KafkaEx.Protocol.Fetch.Message
  alias FictiveWebserver.FactorialResultWaiter

  def handle_message_set(message_set, state) do
    for %Message{value: message} <- message_set do
      [request, result] = String.split(message, ";")
      {request_parsed, _remainder} = Integer.parse(request)
      {result_parsed, _remainder} = Integer.parse(result)

      # IO.inspect(message, label: REGISTER_RESPONSE)

      # If you're really gung-ho on metrics you could measure the ts when it arrived
      #   and when the result is returned to the requester, but we'll ignore that for now.
      FactorialResultWaiter.register_response(request_parsed, result_parsed)
    end

    {:async_commit, state}
  end
end
