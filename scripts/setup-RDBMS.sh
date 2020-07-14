#!/usr/bin/env bash

if  [[ "$RDBMS" = MariaDB* ]]; then
  readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -8)
  docker run --rm --name=$RDBMS -d -p 127.0.0.1:3306:3306 \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=sodbxtest2 \
    mariadb/server:$DOCKER_IMAGE_VERSION
elif  [[ "$RDBMS" = MySQL* ]]; then
    readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -6)
    docker run --rm --name=$RDBMS -d -p 127.0.0.1:3306:3306 \
      -e MYSQL_ROOT_PASSWORD=secret \
      -e MYSQL_ROOT_HOST=% \
      -e MYSQL_DATABASE=sodbxtest2 \
      mysql/mysql-server:$DOCKER_IMAGE_VERSION
fi;
