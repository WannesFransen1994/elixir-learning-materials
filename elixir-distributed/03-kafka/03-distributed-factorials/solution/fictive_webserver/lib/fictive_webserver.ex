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

    KafkaEx.produce(request)
  end
end
