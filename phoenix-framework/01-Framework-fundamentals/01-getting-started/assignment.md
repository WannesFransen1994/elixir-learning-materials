# Assignment

## Task 01: make a new page

This task is an easy one. Generate a new umbrella project and run it. If you go to localhost:4000 in your browser, you'll end up on the index page.

Now we want a second page. Let's say `/hello-world` should display the text "Hello World" in your browser.

_Tip: you'll only have to be in your `app_name_umbrella/apps/app_name_web` folder._

## Task 02: generate a random number

Display a page which generates a random number. Do note: the actual generation of the number should be done in your domain logic app (app_name_umbrella/apps/app_name_web).

## Resources

* [https://hexdocs.pm/phoenix/installation.html](https://hexdocs.pm/phoenix/installation.html)
* [https://hexdocs.pm/phoenix/up_and_running.html](https://hexdocs.pm/phoenix/up_and_running.html)
* [https://hexdocs.pm/phoenix/1.3.0/adding_pages.html](https://hexdocs.pm/phoenix/1.3.0/adding_pages.html) -> a bit outdated, but still applicable
* Can't host a dabase on your machine? Try [remotemysql.com](https://remotemysql.com/)

## Docker database

Some general commands:

```bash
# Show running containers
docker container ls
# Show all containers
docker container ls -a
# Stop a container
docker container stop CONTAINER_NAME
# Remove a container
docker container rm CONTAINER_NAME

# Verify that a certain port is open
netstat -tulpn
```

### MySQL

You can read the [docs](https://hub.docker.com/_/mysql) or immediately execute some commands:

```bash
# Container name = some-mysql
# Portforward host port 3306 to guest port 3306
# Set the environment variable MYSQL_ROOT_PASSWORD which will be the default password of the root user
docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=t -d mysql
# Start the container in interactive mode
docker start -i some-mysql
```

### PostgreSQL

You can read the [docs](https://hub.docker.com/_/postgres)

```bash
# Container name = some-postgres
# Portforward host port 5432 to guest port 5432
# Set the environment variable POSTGRES_PASSWORD which will be the default password of the postgres user
docker run --name some-postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
# Start the container in interactive mode
docker start -i some-postgres
```
