# Distributed factorials w/ Kafka

The goal of this exercise is to create a distributed factorials application that utilizes multiple computers to calculate large factorials as quickly as possible.

## Task 1: Think how the architecture will look like

Just like in real life, before we can go and have fun with coding, we have to think. Some questions we should ask ourselves are:

* What do we want to make?
* What microservice like architecture will be the easiest to scale?
* How do we achieve the highest throughput?
* How do we keep track of the answer of a request?

Get into a comfortable position and think... Make some sketches, how do you think a viable solution will look like?

...

The approach that we'll go for is the following:

```text
              Fictive webserver
    (app which is interacted with through iex)
               ↓              ↑
==================================================
= ++++++++++++++              ++++++++++++++++++ =
= + TODO-TOPIC +    Kafka     + FINISHED-TOPIC + =
= ++++++++++++++              ++++++++++++++++++ =
==================================================
      |                                 ↑
      |-------------------------------  |
      |              ↓               ↓  ↑←---←
      ↓              ↓               ↓  |    |
     Worker1        Worker2         WorkerN  |
         ↓               ↓                   |
         →---------------→------------------→↑
```

A short explanation here:

* Our fictive webserver (which for now is a basic mix project) will publish factorials that need to be calculated.
* The workers receive / listen to the `TODO-TOPIC` topic. After which they'll calculate the result and publish it to the `FINISHED-TOPIC`
* Upon publishing to the `TODO-TOPIC` topic, we will get a result (which contains an offset of the record if you've configured your `ack` setting right).
  * The Fictive webserver needs to know though what result belongs to what request. A common way to do this is to provide some kind of UUID (e.g. in a webshop related context, this could be the customer ID, transaction ID, product ID, ...), but in our case we can just say "this value was the request".
  * If, by any chance, 2 request with the same value are sent to kafka (and the webserver is waiting for both responses), the first message that's produced to the `FINISHED-TOPIC` will be the answer to both requests. _Note: In normal use-cases this is not the case! A UUID approach is more common. Kafka is also mostly used with asynchronous events that don't immediately need to reply to the requester. E-mails, transaction processing, metrics, etc... are common use-cases._

_Note: You should immediately ask yourself the question "what if I want to scale the webserver"? How will the message flow then look like?_

We can see that we'll have to write 2 applications. There will only be one webserver, while there will be multiple workers.

## Task 2: Creating and deleting topics

You'll have to start with the basics. Provide 2 functions in your `FictiveWebserver` API module:

1. Create an app (add the `--sup` option for in the future).
2. Add the appropriate [dependency](https://hex.pm/packages/kafka_ex).
   * When you add the dependency (and then try to run the app), you might get an error.
   * Add the necessary configuration. _(`brokers` is the utmost minimum information)_
3. `FictiveWebserver.create_topic/0` -> make sure that the following settings are set:
   * There are 2 partitions. You can read more about partitions and consumers <!-- markdown-link-check-disable --> [here](TODO) <!-- markdown-link-check-enable -->.
   * When producing, an ack of at least one broker needs to be sent back.
4. `FictiveWebserver.delete_topic/0`
5. Create the `factorials-to-be-calculated` topic manually.

_Check the `create_topics` [api function](https://hexdocs.pm/kafka_ex/KafkaEx.html#create_topics/2) and the [associated struct](https://hexdocs.pm/kafka_ex/KafkaEx.Protocol.CreateTopics.html) documentation. Tip: Make the struct in your iex shell and you'll see what the expected values are._

## Task 3: Producing factorials-to-be-calculated

Generate a new project for the fictive webserver. The first goal will be to produce an event - a factorial that needs to be calculated.

You can follow these steps:

1. Make a function that does nothing else than output a number to your screen. Provide a function that accepts 2 arguments (`FictiveWebserver.generate_number(max, min)`).
2. In you `iex` shell (perhaps with a compiled module), produce an event to a topic.
   * Use the `KafkaEx.Protocol.Produce.Message` struct to create a message.
   * Create a produce request message (with a basic acknowlegdment).
   * Send the request (and look at the return values!). Collect the offsets of the messages.
   * Feel free to verify whether your produced events have arrived with `kafka-console-consumer` (don't forget the `--from-beginning` option if you're not consuming in real-time!).
3. Refactor the previous function so that it produces an event with the number to the topic.
4. Print out the offset after producing the event.
   * You can expect output like:

   ```elixir
     iex> FictiveWebserver.generate_number 40000, 20000
    {:ok, 20}
   ```

_Note: If you have one partition, the offset will increment nicely. If you have 2 partitions, you'll see that an offset belongs to a partition as they don't increment nicely._

## Task 4: Creating a consumer

Now that the `factorials-to-be-calculated` are on Kafka, we'll have to write a consumer that processes this.

1. Create an app (add the `--sup` option as you'll write a consumer)
2. Add the dependency and configuration
3. Start a consumer, follow these steps:
   * Read the [documentation regarding consumers](https://hexdocs.pm/kafka_ex/KafkaEx.GenConsumer.html).
   _Don't worry if you don't understand all the kafka-related terminology. Our goal is not to make you Kafka experts, but to understand how Kafka can help with distributed application architecture._
   * Create your `FactorialConsumer` module.
   * At first, implement a `handle_message_set/2` callback and just print all messages in a batch on the screen. To gain extra insights, include the PID of the process in the debug message.
   * Start a `ConsumerGroup` in your application its children. _The [docs](https://hexdocs.pm/kafka_ex/KafkaEx.ConsumerGroup.html) will help you!_
   * with `:observer.start` -> applications, find the worker PID's.
4. **make sure you have 2 partitions** and count your workers processes / consumers. You should have 2 workers. Start another worker node **that is not connected to another node** and verify the workers again. You should have only 1 worker now / node. Stop one node and wait a while. After a while, you should see that the worker nodes are increased again to 2 consumers.

_Note: When looking at the solution code, also look at the [solution.exs](./solution/fictive_webserver/solution_steps.exs) file. This is to illustrate how to tackle these problems step by step._

## Task 5: Publishing the result

Now that we've received the message, calculate the factorial. After that write it to the `factorials-result` topic **without manually creating the topic**. You'll see that when you write a message to a non-existent topic, it'll be created automatically.

In this message the following should be included:

* Due to our unique use case where the requestor wants to keep somehow track of a message (and its result), it'd be normal to add a UUID or some other kind of unique value. We've already discussed this in Task 1 and will just include a pair of values (factorial-to-be-calculated value + result).
* We have some serialization issues. We cannot push tuples or other Elixir-unique datastructures onto Kafka (which doesn't understand it). You could use Apache Avro or Protobuf, but for now we'll convert it into a simple string representation.
* An example would be:

```text
4;24
5;120
3;6
30;265252859812191058636308480000000
```

Publish this to the `factorials-result` topic. Don't worry about the partitions. If you take some factorials between 10k-20k, you should notice that some computers might start working rather hard. Adjust the factorial size only to high amounts after you've checked your implementation with small values!

_Note: With :observer you can check the load of your system._

Verify that your results are published correctly with `kafka-console-consumer`.

## Task 6: Consuming the result

Now that we've got our processed result, it is time for our `FictiveWebserver` to consume the `factorials-result` topic.

Though first of all, let's create a `GenServer` process (e.g. `FactorialResultWaiter`) which will keep track of the requests (and send back the response).

* Create the following module with the following function:
  * `FactorialResultWaiter` module.
  * `wait_for_response(factorial_requested, pid_requester, ts_before_produce, ts_after_produce_ack)` function. _We include the timestamps so that, if you want to, you can do an analysis later on as to how long certain aspects take._
* When a request is made (and the offset is committed), register your factorial with the `FactorialResultWaiter`.
  * Think about how you'll reply to your caller. You'll have to reply late.
  * Think about duplicates. When, by chance, 2 times the same factorials have been requested by another process, how will store this in your state?
* Start a consumer(group) with a consumer that reads this value. First, just dump it to the screen.
* Let the consumer send a message to `FactorialResultWaiter` when a result arrives. Do this with the `result_arrived(factorial_requested, result)` function.
* At last, remove the entry from the state in `FactorialResultWaiter` when the result message has arrived. Reply on the waiting GenServer call as well.

_Note: When starting a consumer, it'll have to synchronize in the beginning. As soon as the debug information "Joined consumer group...", you're good to go. Look at the output (and the timestamps!) below:_

```text
09:58:26.452 [debug] Successfully connected to broker "localhost":9092
09:58:26.458 [debug] Establishing connection to broker 1: "localhost" on port 9092
09:58:26.459 [debug] Successfully connected to broker "localhost":9092
09:58:26.465 [debug] Successfully connected to broker "localhost":9092
09:58:26.466 [debug] Establishing connection to broker 1: "localhost" on port 9092
09:58:26.467 [debug] Successfully connected to broker "localhost":9092
Interactive Elixir (1.10.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
09:58:54.415 [debug] Joined consumer group factorials_result_consumer_group generation 14 as kafka_ex-55311401-fa7c-443b-a89e-f79eb7bef70a
09:58:54.441 [debug] Successfully connected to broker "localhost":9092
09:58:54.443 [debug] Establishing connection to broker 1: "localhost" on port 9092
09:58:54.444 [debug] Successfully connected to broker "localhost":9092
```

In the end, you should be able to use your system like:

```elixir
iex> FictiveWebserver.generate_number 10000,2000
Elixir.TIME_INFORMATION_REPORT: "produce delay (w/ ack) cost (in milliseconds): 3 \t | total time cost: 36"
19492884327 ... # lots of numbers
```

## Task 7: Emulating insights a high traffic system

TODO: provide information regarding metrics, perhaps use protobuf / Apache avro, but this isn't a priority for now. Grafana insights, aggregated logs, etc... are all very useful. Not a priority for now.
