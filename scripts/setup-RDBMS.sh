#!/usr/bin/env bash

if  [[ "$RDBMS" = MariaDB* ]]; then
  readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -8)
  docker run -d -p 127.0.0.1:3306:3306 \
    -e MYSQL_ROOT_PASSWORD=sodbxtest \
    -e MYSQL_DATABASE=sodbxtest2 \
    -e MYSQL_USER=sodbxtest \
    -e MYSQL_PASSWORD=sodbxtest \
    mariadb/server:$DOCKER_IMAGE_VERSION
elif  [[ "$RDBMS" = MySQL* ]]; then
    readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -6)
    docker run --name=rdbms-server -d -p 127.0.0.1:3306:3306 \
      -e MYSQL_ROOT_PASSWORD=secret \
      -e MYSQL_ROOT_HOST=% \
      -e MYSQL_DATABASE=sodbxtest2 \
      mysql/mysql-server:$DOCKER_IMAGE_VERSION
    sleep 10
    docker exec rdbms-server mysql --user=root --password=secret --execute "CREATE DATABASE IF NOT EXISTS sodbxtest2; CREATE USER sodbxtest@localhost IDENTIFIED BY 'sodbxtest'; GRANT ALL PRIVILEGES ON *.* TO 'sodbxtest'@'localhost'; FLUSH PRIVILEGES;" --verbose
fi;
