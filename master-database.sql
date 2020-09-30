CREATE USER IF NOT EXISTS 'app_user'@'%' IDENTIFIED BY 'app_user_pass';
GRANT ALL PRIVILEGES ON *.* TO 'app_user'@'%';
flush privileges;


CREATE DATABASE IF NOT EXISTS test;
USE test;
drop table if exists products;
drop table if exists orders;
CREATE TABLE IF NOT EXISTS `orders` (
      `id` INT(11) auto_increment NOT NULL,
      `order_code` varchar(40) DEFAULT NULL,
      `insert_date` datetime DEFAULT NULL,
      PRIMARY KEY (`id`)
) ENGINE=InnoDB;
CREATE TABLE products (
      `id` INT(11) auto_increment NOT NULL,
      `order_id` INT(11) NOT NULL,
      `product_code` varchar(40) DEFAULT NULL,
      `insert_date` datetime DEFAULT NULL,
      PRIMARY KEY (id),
      CONSTRAINT products_FK FOREIGN KEY (order_id) REFERENCES orders(id)
) ENGINE=InnoDB;

