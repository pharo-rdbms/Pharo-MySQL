#!/usr/bin/env bash

if  [[ "$RDBMS" = MariaDB* ]]; then
  readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -8)
  docker run -d -p 127.0.0.1:3306:3306 \
    -v $GITHUB_WORKSPACE/scripts/db:/docker-entrypoint-initdb.d \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=sodbxtest2 \
    mariadb/server:$DOCKER_IMAGE_VERSION
elif  [[ "$RDBMS" = MySQL* ]]; then
    readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -6)
    docker run -d -p 127.0.0.1:3306:3306 \
      -v $GITHUB_WORKSPACE/scripts/db:/docker-entrypoint-initdb.d \
      -e MYSQL_ROOT_PASSWORD=secret \
      -e MYSQL_ROOT_HOST=% \
      -e MYSQL_DATABASE=sodbxtest2 \
      mysql/mysql-server:$DOCKER_IMAGE_VERSION
fi;
echo "Waiting for MySQL to start..."
sleep 30
readonly DOCKER_CONTAINER_ID=$(docker ps -q)
docker exec $DOCKER_CONTAINER_ID mysql --user=root --password=secret --execute="select user, host from mysql.user order by user;"
