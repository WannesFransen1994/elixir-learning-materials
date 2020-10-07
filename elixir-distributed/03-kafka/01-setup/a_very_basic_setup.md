# Basic setup guide

In order to get started with Kafka, you'll need to make sure that you have enough memory. A rough estimate of 2GB should be enough to get you started with these exercises.

The above requirements is for the whole Kafka section. This is assuming that you can run Docker images. It is possible to do this with virtual machines (VM's), but you'll most likely end up with using a lot more memory.

First read the necessary [introduction](../../reading_materials/kafka/kafka_intro.md) which explains what Kafka is and for what purposes you can use it.

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
  | The part below is docker-managed
  |
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
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
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
* Regarding the `KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR`, feel free to ignore the details regarding this setting for now. If you want to go in depth over [this setting](https://kafka.apache.org/documentation/#offsets.topic.replication.factor), I'd suggest you look at this tutorial regarding [offsets](https://www.learningjournal.guru/courses/kafka/kafka-foundation-training/offset-management/). To put it in a nutshell, every consumer has an offset and there's also a committed offset. In order to keep track of this, they keep a topic with this information. Normally this has a replication factor of 3 (thus needing 3 brokers), but for a single node setup we will put this on 1.

## Running our containers

Now that we've got our basic docker-compose file, let's run it with:

```bash
# Renamed the docker compose file to 'kafka_basic.yml'
$ docker-compose -f kafka_basic.yml up
```

With this command we tell docker compose to start the services listed in the file. When you do this, you should see something like:

```txt
Creating zookeeper_1 ...
Creating zookeeper_1 ... done
Creating kafka_1 ...
Creating kafka_1 ... done
Attaching to zookeeper_1, kafka_1
zookeeper_1    | ===> User
kafka_1        | ===> User
...
```

Verify that the containers are running with:

```bash
$ docker container ls -a
CONTAINER ID        ...       STATUS                    PORTS                          NAMES
2478186ebee6        ...       Up About a minute         0.0.0.0:9092->9092/tcp         kafka_1
ffef4bceb320        ...       Up About a minute         2181/tcp, 2888/tcp, 3888/tcp   zookeeper_1
```

When you look at the ports, we see that Zookeeper uses the following ports (internally) by default:

* 2181 -> port on which clients will connect to. (In our case, these are Kafka clients.)
* 2888 -> connect to other peers. Necessary to agree upon the order of updates, connect followers to the leader.
* 3888 -> leader election

If you wish to know more in-depth knowledge regarding the zookeeper ports, you can always check the [documentation](https://zookeeper.apache.org/doc/r3.3.3/zookeeperStarted.html).

_You can also see in the `PORTS` section that the port 9092 is bound to our host. Meaning, when we do a request to localhost:9092 (on the host!), it'll be redirected to our docker container._

## Deleting the containers

You'll probably have to fiddle with your containers a few times if things doesn't go as planned. To make sure  that you have a completely clean "start", you can always remove your containers with:

```bash
docker container rm kafka_1 zookeeper_1
```

## Debugging the containers

Often logs can be overwhelming or mistakes are overlooked. In this section we'll give you some hints how you can verify that your containers are running as expected.

### Confirming whether they are running or not

At last, we'll want to verify that our containers are running as expected. Open a new terminal and connect to your zookeeper container with:

```bash
# Shell one
$ docker exec -it zookeeper_1 /bin/bash
[appuser@ffef4bceb320 ~]$
# Shell two
$ docker exec -it kafka_1 /bin/bash
[appuser@2478186ebee6 ~]$
```

The `exec` stands for execute. This lets you execute something on the remote container. We also provide the `-i` and `-t` options so that we can have a `interactive` pseudo `tty` terminal. After that we have to define what container, and at last what shell you'll use (e.g. `/bin/sh` or `/bin/bash`).

Now we can execute commands on our containers, just like we'd do on a separate machine. Let's take a look at the IP addresses:

```bash
# On the host machine when the containers are running
$ ip -br a # -br stands for brief, a for address
lo               UNKNOWN        127.0.0.1/8 ::1/128 # -> local loopback, ignore this
enp0s31f6        UP             10.24.190.101/21 fe80::5a05:89a3:e00:4ab2/64 # -> cable connection
docker0          DOWN           172.17.0.1/16 fe80::42:53ff:fe2f:9a92/64
br-9c469add1cb5  UP             172.18.0.1/16 fe80::42:e7ff:fe6e:c3dc/64
# ...

# When we run the same command when the containers are down:
$ ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128
enp0s31f6        UP             10.24.190.101/21 fe80::5a05:89a3:e00:4ab2/64
docker0          DOWN           172.17.0.1/16 fe80::42:53ff:fe2f:9a92/64
br-9c469add1cb5  DOWN           172.18.0.1/16 fe80::42:e7ff:fe6e:c3dc/64 # -> status changed to down!

# Connect to zookeeper_1 container (start the machines again)
$ cat /proc/net/fib_trie | grep "|--"
# ...
           |-- 172.18.0.0
           |-- 172.18.0.2 # -> this is our IP address
# ...

# Connect to kafka_1 container
$ cat /proc/net/fib_trie | grep "|--"
# ...
           |-- 172.18.0.0
           |-- 172.18.0.3 # -> this is our IP address
# ...
```

A lot is happening in the above commands. A short recap:

* First we look at our current IP address on the host.
* We also confirm (by shutting down the containers) that the `br-9c469add1cb5` interface goes down.
* When we start the containers again, we confirm their IP address. Feel free to ping each other.

### Confirming the configuration

At last, we'll check whether our Zookeeper started up correctly. Let us ask for the `stat` (status) of the `zookeeper_1` container.

```bash
# on the zookeeper_1 container
$ echo stat | nc localhost 2181
stat is not executed because it is not in the whitelist.
```

This command is, as the output says, not on the whitelist. Let us adjust the docker image a little bit so that we can execute this command:

```yml
# add the following line to your zookeeper_1 environment variables:
      KAFKA_OPTS: "-Dzookeeper.4lw.commands.whitelist=*"
```

Now that we've whitelisted everything, let us restart the containers and execute the `stat` command again:

```bash
$ echo stat | nc localhost 2181
Zookeeper version: 3.5.8-f439ca583e70862c3068a1f2a7d4d068eec33315, built on 05/04/2020 15:53 GMT
Clients:
 /127.0.0.1:55218[0](queued=0,recved=1,sent=0)
 /172.18.0.3:37690[1](queued=0,recved=62,sent=63) # -> our Kafka client!

Latency min/avg/max: 0/0/6
Received: 66
Sent: 66
Connections: 2
Outstanding: 0
Zxid: 0x48
Mode: standalone
Node count: 26
```

Here we can see that the mode is `standalone` and that we've got one client. It is safe to assume that our first setup is working!

### Analyzing the memory usage

You can also easily see how much memory / CPU your containers are occupying. This can be done with:

```bash
$ docker stats
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT                ...
731fc7667dbc        kafka_1             1.34%               328.6MiB / 15.52GiB   2.07%      ...
942501fe4925        zookeeper_1         0.19%               92.15MiB / 15.52GiB   0.58%      ...
```

## Creating a topic

To make sure everything works as expected, let us create a new topic on Kafka.

Execute the following on your Kafka container:

```bash
$ kafka-topics --create --topic foo --partitions 1 --replication-factor 1 --if-not-exists --zookeeper 172.18.0.2:2181
Created topic foo.
```

Good job! You've created your first topic. Though we had to manually enter our IP address. Thanks to giving our containers names, we can easily enter the container name instead of the IP address (and it'll get resolved automatically!):

```bash
$ kafka-topics --create --topic bar --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper_1:2181
Created topic bar.
```

This should get you started. Make sure that the above basic setup works!
