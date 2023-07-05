### 自定义目录
```
mkdir -p /home/base/gitea
```

### 手续
1. 添加网络名称
```
sudo docker network create 99net
```

2. 如原有数据库未配置网络，需修改数据库桥接网络
```
sudo docker run -d -p 3306:3306 --name code-db --network 99net --network-alias code-db --restart=always -v /home/base/mariadb/data/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=[PASSWORD] mariadb
```
选项--network [networkname]和--network-alias [container_aliasname]为需要互访的容器添加桥接网络，数据库和gitea都要加

3. 启动gitea，配置数据库
```
sudo docker run --name gitea --network 99net --network-alias gitea -d --restart=always -v /home/base/gitea/:/data -p 3000:3000 -p 10022:22 gitea/gitea
```
配置文件在/home/base/gitea/gitea/conf/app.ini，关联数据库使用数据库的[container_aliasname]

建议关闭容器的ssh

### 启动服务后修改数据库和gitea的访问控制
```
iptables -L DOCKER -n --line-number
sudo iptables -R DOCKER 1 -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.2 --dport 3306 -j ACCEPT
sudo iptables -R DOCKER 2 -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.3 --dport 3000 -j ACCEPT
```

### docker-compose.yml

```yml
version: '2'
services:
  code-db:
    #-------------------------------------------------------------------------------------
    image: mariadb:latest
    #-------------------------------------------------------------------------------------
    container_name: code-db
    restart: always
    #-------------------------------------------------------------------------------------
    ports:
      - 3306:3306
    networks:
      - 99net
    expose:
      - 3306
    volumes:
      - /home/base/mariadb/data/:/var/lib/mysql
    environment:
      - "MYSQL_ROOT_PASSWORD=[PASSWORD]"
      - "MYSQL_USER=gitea"
      - "MYSQL_PASSWORD=[PASSWORD]"
      - "MYSQL_DATABASE=gitea"

  code-git:
    #-------------------------------------------------------------------------------------
    image: gitea/gitea:latest
    #-------------------------------------------------------------------------------------
    container_name: code-git
    restart: always
    #-------------------------------------------------------------------------------------
    networks:
      - 99net
    ports:
      - 3000:3000
    volumes:
      - /home/base/gitea/:/data
    depends_on:
      - code-db
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - DB_TYPE=mysql
      - "DB_HOST=code-db:3306"
      - DB_NAME=gitea
      - DB_USER=gitea
      - "DB_PASSWD=[PASSWORD]"

networks:
  99net:
    driver: bridge
```