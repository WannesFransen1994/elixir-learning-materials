# A multinode cluster

For Zookeeper, multinode cluster also referred to as ensemble. Suggested in 3 - 5 - ... (odd number) clusters due to the majority quorum algorithm.

TODO: Write this section.

_Dumping docker compose file for future reference._

```yml
version: "3.3"

services:
  zookeeper_1:
    image: confluentinc/cp-zookeeper:latest
    container_name: zookeeper_1
    environment:
      ZOOKEEPER_SERVER_ID: 1
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_SERVERS: zookeeper_1:2888:3888;zookeeper_2:2888:3888;zookeeper_3:2888:3888
      ZOOKEEPER_TICK_TIME: 2000
      ZOOKEEPER_INIT_LIMIT: 5
      ZOOKEEPER_SYNC_LIMIT: 2
      KAFKA_OPTS: "-Dzookeeper.4lw.commands.whitelist=*"

  zookeeper_2:
    image: confluentinc/cp-zookeeper:latest
    container_name: zookeeper_2
    environment:
      ZOOKEEPER_SERVER_ID: 2
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_SERVERS: zookeeper_1:2888:3888;zookeeper_2:2888:3888;zookeeper_3:2888:3888
      ZOOKEEPER_TICK_TIME: 2000
      ZOOKEEPER_INIT_LIMIT: 5
      ZOOKEEPER_SYNC_LIMIT: 2
      KAFKA_OPTS: "-Dzookeeper.4lw.commands.whitelist=*"

  zookeeper_3:
    image: confluentinc/cp-zookeeper:latest
    container_name: zookeeper_3
    environment:
      ZOOKEEPER_SERVER_ID: 3
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_SERVERS: zookeeper_1:2888:3888;zookeeper_2:2888:3888;zookeeper_3:2888:3888
      ZOOKEEPER_TICK_TIME: 2000
      ZOOKEEPER_INIT_LIMIT: 5
      ZOOKEEPER_SYNC_LIMIT: 2
      KAFKA_OPTS: "-Dzookeeper.4lw.commands.whitelist=*"

  kafka_1:
    image: confluentinc/cp-kafka:latest
    container_name: kafka_1
    depends_on:
      - zookeeper_1
      - zookeeper_2
      - zookeeper_3
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper_1:2181,zookeeper_2:2181,zookeeper_3:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka_1:9092
    ports:
      - "9092:9092"


  kafka_2:
    image: confluentinc/cp-kafka:latest
    container_name: kafka_2
    depends_on:
      - zookeeper_1
      - zookeeper_2
      - zookeeper_3
    environment:
      KAFKA_BROKER_ID: 2
      KAFKA_ZOOKEEPER_CONNECT: zookeeper_1:2181,zookeeper_2:2181,zookeeper_3:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka_2:9092
    ports:
      - "9093:9092"
```
