# Basic setup guide

In order to get started with Kafka, you'll need to make sure that you have enough memory. A rough estimate of 2GB should be enough to get you started with these exercises.

The above requirements is for the whole Kafka section. This is assuming that you can run Docker images. It is possible to do this with virtual machines (VM's), but you'll most likely end up with using a lot more memory.

First read the necessary [reading materials\[TODO\]](TODO) which explains what Kafka is and for what purposes you can use it.

## Getting started

We'll start with creating a simple Zookeeper and Kafka container. We'll be using the docker images from [confluent](https://hub.docker.com/u/confluent). While there is an [example docker compose.yml](https://github.com/confluentinc/cp-docker-images/blob/5.3.3-post/examples/kafka-cluster/docker-compose.yml) file, we'll slightly adjust this in order to make some aspects more clear / consisten with how you'd do it in a production environment.

Let's start. Verify that you have `docker` and `docker-compose` installed. You can do this with:

```bash
$ docker --version
Docker version 19.03.13, build 4484c46d9d
$ docker-compose --version
docker-compose version 1.17.1, build unknown
```

In order to start the containers, we'll first sketch a simple overview of what the network topology will (probably) look like:

```text
##################
# ISP PUBLIC IP  #
##################
  |
  | - <----- Your router NAT's it to a 192.168.X.X IP address.
  |
####################
# Private IP of PC #
####################
  |
  |        Below part is docker-managed
## \ #############################
#   -> Docker network drivers    #
#              |||               #
#              |||               #
#             / | \              #
#            /  |  \             #
#           /   |   \            #
#   Container1  |    Container 2 #
#           Container N          #
##################################
```

_An overview of common private network IP addresses can be found at [wikipedia](https://en.wikipedia.org/wiki/Reserved_IP_addresses)._

In the above sketch you can see that a public IP is converted into multiple private addresses. When your computer receives a private IP address, it'll (probably) be able to surf the internet thanks to NATting. You won't use the private IP directly, but it'll be translated into a public IP address and back.

Depending on whether you use docker-compose or docker directly, the networking behaviour will be a little bit different. Docker images that are started directly will use the `bridge` driver by default, while with docker-compose they'll be placed inside an `internal network`. Just like on the above sketch, containers will be able to see their peers defined in the `docker-compose.yml` file.

_More information about this can be found at:_

* _[docker compose networking docs](https://docs.docker.com/compose/networking/)_
* _[docker network drivers](https://docs.docker.com/network/#network-drivers)_

Our goal is to put the Zookeeper and Kafka container in a single network, exposing only the necessary ports. Let's do this with the following `docker-compose.yml` file:

```yml
# Version of the docker-compose file
version: "3.3"

services:
  zookeeper_1:
    image: confluentinc/cp-zookeeper:latest
    container_name: zookeeper_1
    environment:
      ZOOKEEPER_SERVER_ID: 1
      ZOOKEEPER_CLIENT_PORT: 2181

  kafka_1:
    image: confluentinc/cp-kafka:latest
    container_name: kafka_1
    depends_on:
      - zookeeper_1
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper_1:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka_1:9092
    ports:
      - "9092:9092"
```

So a quick overview of the above file:

* First we specify what version the compose file adheres to.
* After that, we define the services that we want to run. One service will be one container.
* `zookeeper_1` and `kafka_1` are the service names.
* Next we specify what image that service is. We also specify that we'll be using a `container_name` instead of the default generated name by Docker.
* For the zookeeper, we give it a unique ID. This has to be unique between the zookeeper cluster. Same for the `KAFKA_BROKER_ID` environment variable.
* With `ZOOKEEPER_CLIENT_PORT` we specify the port on which the Zookeeper will listen for clients. This is configured in our Kafka service with `KAFKA_ZOOKEEPER_CONNECT`. _Note that our `zookeeper_1` will be resolved to the IP address of our other container._
* Kafka will be listening on port 9092. This is the port of the containerized machine! Not of our host machine. That's why we add the `ports` section. _(The `ports` section has a notation of `EXTERNAL_PORT:INTERNAL_PORT`. Meaning that the host port 9092 will be redirected to the internal 9092 port.)_

TODO: add section for running, watching the logs, removing containers, debugging.
