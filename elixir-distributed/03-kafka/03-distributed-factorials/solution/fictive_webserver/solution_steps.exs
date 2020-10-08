# 1. mix new fictive_webserver.exs --sup

# 2. function implementation
#   def generate_number(max, min \\ 0), do: :rand.uniform(max - min) + min

# 3. A: see mix.exs
# 3. B: see config/config.exs

# 4. A:
#   m1 = %KafkaEx.Protocol.Produce.Message{value: "10"}
# 4. B:
#   request = %KafkaEx.Protocol.Produce.Request{topic: "test-topic", partition: 0, required_acks: 1, messages: [m1]}
# 4. C:
#   {:ok, offset_of_message} = KafkaEx.produce request
# 4. D: kafka-console-consumer --topic test-topic --bootstrap-server localhost:9092 --from-beginning
