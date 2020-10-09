defmodule FictiveWebserver do
  alias KafkaEx.Protocol.CreateTopics.TopicRequest
  alias KafkaEx.Protocol.Produce.Request

  @topic "factorials-to-be-calculated"

  @create_topic_req %TopicRequest{topic: @topic, num_partitions: 2, replication_factor: 1}

  @default_req %Request{
    topic: @topic,
    required_acks: 1
  }

  def create_topic() do
    KafkaEx.create_topics([@create_topic_req])
  end

  def delete_topic() do
    KafkaEx.delete_topics([@topic])
  end

  def generate_number(max, min \\ 0) do
    number = :rand.uniform(max - min) + min
    message = %KafkaEx.Protocol.Produce.Message{value: Integer.to_string(number)}
    request = %{@default_req | messages: [message]}

    ts_before = DateTime.utc_now()

    {:ok, _offset} = KafkaEx.produce(request)
    # IO.inspect(offset, label: __MODULE__.OFFSET.REPORT)
    ts_after = DateTime.utc_now()

    {response, _time_information} =
      FictiveWebserver.FactorialResultWaiter.wait_for_response(number, ts_before, ts_after)

    ts_final = DateTime.utc_now()

    produce_cost = DateTime.diff(ts_after, ts_before, :millisecond)
    total_cost = DateTime.diff(ts_final, ts_before, :millisecond)

    logging_message =
      "produce delay (w/ ack) cost (in milliseconds): #{produce_cost} \t | total time cost: #{
        total_cost
      }"

    IO.inspect(logging_message, label: TIME_INFORMATION_REPORT)

    response
  end
end
