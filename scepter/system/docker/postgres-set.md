
### 自定义目录
```
mkdir -p /home/base/postgres/data
```

### 运行
```
sudo docker run -d -p 5432:5432 --name svr-db --network 99net --network-alias svr-db --restart=always -e PGDATA=/data -v /home/base/postgres/data:/data -e POSTGRES_PASSWORD=[PASSWORD] postgres
```

### 绑定防火墙
启动服务后修改数据库的访问控制
```
iptables -L DOCKER -n --line-number
iptables -R DOCKER 14 -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.6 --dport 5432 -j ACCEPT
```