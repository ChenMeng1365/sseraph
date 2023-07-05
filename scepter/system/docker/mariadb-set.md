
### 自定义目录
```
mkdir -p /home/base/mariadb/data/
```

### 运行
```
sudo docker run -d -p 3306:3306 --name mariadb --restart=always -v /home/base/mariadb/data/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=[PASSWORD] mariadb
```

### 修改管理员口令
mysql -uroot -p

### 问题:"导入数据库出现：Row size too large (> 8126)"
```
docker exec -it mariadb /bin/bash
```
修改/etc/mysql/mariadb.cnf
```
innodb_log_file_size=1024M
innodb_strict_mode=0
```
重启容器
```
docker restart mariadb
```
新建容器时就追加一下这个，以免导入数据时报错

### 绑定防火墙
启动服务后修改数据库的访问控制
```
iptables -L DOCKER -n --line-number
sudo iptables -R DOCKER 1 -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.2 --dport 3306 -j ACCEPT
```