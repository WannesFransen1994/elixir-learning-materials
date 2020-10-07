# Introduction to Kafka

When you start developing large-scale applications, there will come a point where one monolith application will no longer be feasible. Even when dividing it up in multiple microservices, communication between applications and focussed scaling while still having a reliable application will become a huge challenge.

Let's take a simple example. Imagine you have a website which reencodes / resizes videos and/or images. With every step along the way (user registers, uploads a video, clicks on a lot of links) data could be generated.

We will take a look at how such a fictive system could be alternatively designed with Kafka.

## A fictive reencoding website

### Current situation

First let us talk about a fictive situation where the application architecture is becoming hard to manage.

We have for example:

* Web server
  * This is the frontend server, which creates metric data (e.g. what link was clicked on, how long until the response takes, ...)
* RDBMS storing user-related data ()
  * Generates logs
  * Maybe even clustered setup - slaves, master, sharding, etc...
* NoSQL database such as Minio
  * High performance object store (for big data)
  * Can be used in a distributed / sharded setup
  * Generates logs
* Reencoding servers
* Activity monitoring
* Database monitoring
* Continuous metrics analysis

If you'd try to map this communication, you'd immediately see that it'd be hard to get a clear and easy understanding of the communication flow. Focussed scaling would also prove to be a challenge.

Couldn't this be designed in a better way?

### A possible Kafka alternative

You can think of Kafka of an application that uses the publish-subscribe message system architecture to provide topics to clients which they can subscribe on. Kafka uses the following terminology:

* **Message** - A unit of data.
* **Schema** - **Messages** can have a structure, or **Schema**, imposed on the content.
* **Topic** - **Messages** are categorized by a topic. A close analogy could be a filesystem folder in which you put **Messages** that belong to it.
* **Producer** - one who creates data and publishes it to a **Topic**.
* **Consumer** - one who reads data from a **Topic**.

Now that we know the basic terminology of a Kafka system, we can think of a high-level application architecture overview.

```text
Frontend 1    Frontend 2    DB_cluster    Minio
  |  ↓           |  ↓          |  ↑        ↑ |
  |  ↓----------→|→-----------→|--↑        ↑ |
  |  ↓----------→|→-----------→|→----------↑ |
  ↓              ↓             ↓             ↓
===============================================
=                Kafka cluster                =
===============================================
 |    ↑        |    ↑         |          |
 ↓    |        ↓    |         ↓          ↓
Reencoding    Reencoding   Metrics   Monitoring
Server 1      Server 2     Analysis
```

While some parts might be incomplete (or incorrect), we can immediately see that the communication overview will be more structured, data flow more manageable, and so on.

In the above example, the frontend doesn't need to know the reencoding servers directly. It can just publish a message "reencode this please". The metrics application doesn't need to know all the apps (or all the apps don't need to worry about the metric analysis app), it can just read from the topic what the data is and analyse it.

## Kafka and Zookeeper

Kafka servers, also refererred to as Kafka Brokers, can't exist on their own. They need a coordination application which is called `Zookeeper`.

The communication between Kafka Brokers and Zookeeper servers are minimal. The only communication that happens is regarding metadata of the brokers.

Brokers know who is the leader of a given topic partition _(right now we'll just assume that one topic = one partition, but know that this can be split up)_ thanks to Zookeeper servers.

A simple example with 2 topics and 2 brokers (and a replication factor of 2):

* Topic A its leader is Broker A. It is replicated by Broker B.
* Topic B its leader is Broker B. It is replicated by Broker A

The necessary communication in order to get the above result is because they write their metadata to Zookeeper. This doesn't mean that there is no communication between the Broker instances! Replication isn't done through Zookeeper, but directly between Brokers.

### Zookeeper - goal and purpose

A kafka instance can only be started after a zookeeper is started. This is because zookeeper its purpose is to perform coordination tasks such as:

* Cluster membership. Sends heartbeats to brokers to see who's still alive in the cluster.
* Topic meta information. Store information regarding what topics (and partitions) exists on the brokers.
* Electing a controller. A Controller is a broker which is responsible for managing the leader/follower relationship. If there is a change in the cluster topology (and a new partition leader needs to be elected), the controller will do the necessary administration so that each partition has a guaranteed leader.
* Quota's and ACLs

## Utmost basics

In order to understand the utmost basics, we'll create a very simple producer-consumer example "application".

Look at the exercises to have a very simple setup. Just enough to get you started.

When you're connected to your kafka instance, execute the following commands:

```bash
$ kafka-topics --create --topic my-getting-started-topic --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper_1:2181
Created topic my-getting-started-topic.

$ kafka-console-producer --topic my-getting-started-topic --bootstrap-server localhost:9092
>Hello world 1!
>Hello world 2!
>Hello world 3!
>I'm going to stop creating messages by pressing CTRL+C
>^C[appuser@88a85cd9835f ~]$

$ kafka-console-consumer --topic my-getting-started-topic --from-beginning --bootstrap-server localhost:9092
Hello world 1!
Hello world 2!
Hello world 3!
I'm going to stop creating messages by pressing CTRL+C
^CProcessed a total of 4 messages
```

You just made your first topic, producer and consumer application!
