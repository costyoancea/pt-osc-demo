Started from https://github.com/jamiejackson/docker-mariadb-replication


# Docker Compose

`docker-compose up`

# Convenience Functions

These are a quick way to try this image with a master and a pair of slaves. (As the `docker-compose.yml` is currently configured, none of them persist data.)
```
docker-compose down -v

MYSQL_ROOT_PASSWORD=foopass docker-compose up

cat master-database.sql | docker exec -it db_master mysql -pfoopass 

docker exec -it db_slave1 mysql -uapp_user -papp_user_pass -e 'select count(*) from test.orders'
```

### Insert on master
```
while true; do docker exec -it db_master mysql -uapp_user -papp_user_pass -e "
INSERT INTO test.orders (order_code, insert_date) VALUES (CONCAT('o_',uuid()), NOW());
SET @lastOrderId = LAST_INSERT_ID();
INSERT INTO test.products (order_id, product_code, insert_date) VALUES (@lastOrderId, CONCAT('p_',uuid()), NOW());
INSERT INTO test.products (order_id, product_code, insert_date) VALUES (@lastOrderId, CONCAT('p_',uuid()), NOW());
"; done
```
  
### check on slave:
docker exec -it db_master mysql -pfoopass

docker exec -it db_slave1 mysql -pfoopass -e "SELECT count(*) FROM test.orders"
 
docker exec -it db_slave1 mysql -pfoopass -e "SHOW SLAVE STATUS\G" | grep Sec

### delay slave:
docker exec -it db_slave1 mysql -pfoopass -e "STOP SLAVE;\
CHANGE MASTER TO master_delay=101;\
START SLAVE"


docker exec -it db_master mysql -pfoopass test

docker exec -it toolkit \
pt-online-schema-change \
--max-load=1 \
--alter="MODIFY order_code varchar(50)" \
--statistics \
--alter-foreign-keys-method=rebuild_constraints \
--nocheck-unique-key-change \
--password=app_user_pass \
--execute \
--check-slave-lag=h=db_slave1,P=3306,u=app_user \
--slave-password=app_user_pass \
h=db_master,P=3306,u=app_user,D=test,t=orders 



--alter="MODIFY id int(11) NOT NULL auto_increment" \


--alter="MODIFY order_code varchar(50)" \
rebuild_constraints drop_swap

#fail: 
--alter="MODIFY id bigint NOT NULL auto_increment" \


docker exec -it db_master mysql -uroot -pfoopass  
docker exec -it db_master mysql -uapp_user -papp_user_pass



while true; do docker exec -it db_slave1 mysql -uapp_user -papp_user_pass test -e "
SHOW tables"; done

Hi,
For who is interested, I want to present a demo about pt-online-schema-change (https://www.percona.com/doc/percona-toolkit/LATEST/pt-online-schema-change.html). This Percona tool can be used to make DB changes without downtime. 
I will explain how it works and how can be used in a master-slave setup.

If you think other persons might be interested in this, please forward the meeting.
