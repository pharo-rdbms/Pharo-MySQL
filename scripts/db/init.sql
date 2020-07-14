CREATE DATABASE IF NOT EXISTS sodbxtest2;
CREATE USER sodbxtest@localhost IDENTIFIED BY 'sodbxtest';
GRANT ALL PRIVILEGES ON *.* TO 'sodbxtest'@'localhost';
FLUSH PRIVILEGES;
