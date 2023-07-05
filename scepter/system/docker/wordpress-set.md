
# Prepare

```shell
docker pull mariadb
docker pull wordpress
docker create network inet
```

```shell
mkdir -p /data/mariadb/data
mkdir -p /data/wordpress
```

# Setting

```shell
docker run -d --name wdps-db -p <outport>:3306 --network inet --network-alias wdps-db -v /data/mariadb/data:/var/lib/mysql \
           -e MYSQL_ROOT_PASSWORD=[ROOTPSWD] -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=[USERPSWD] \
           mariadb

docker run -d --name wdps -p <outport>:80 --network inet --network-alias wdps -v /data/wordpress:/var/www/html/ \
           -e WORDPRESS_DB_HOST=wdps-db:3306 -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=[USERPSWD] \
           wordpress
```

# Post-setting

```shell
iptables -R DOCKER x -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.2 --dport 3306 -j ACCEPT
iptables -R DOCKER x -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.3 --dport 80   -j ACCEPT
```
