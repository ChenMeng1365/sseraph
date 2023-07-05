
# 安装

```shell
mkdir -p /home/base/mysql/data
mkdir -p /home/base/bookstack/public/uploads
mkdir -p /home/base/bookstack/storage/uploads

sudo docker run -d --net 100net \
 -e "MYSQL_ROOT_PASSWORD=[ROOTPSWD]" \
 -e "MYSQL_DATABASE=bookstack" \
 -e "MYSQL_USER=bookstack" \
 -e "MYSQL_PASSWORD=[USERPSWD]" \
 -v "/home/base/mysql/data:/var/lib/mysql" \
 -p 3306:3306 \
 --name="book-db" \
 mysql:5.7.31

sudo docker run -d --net 100net \
 -e "DB_HOST=book-db:3306" \
 -e "DB_DATABASE=bookstack" \
 -e "DB_USERNAME=bookstack" \
 -e "DB_PASSWORD=[USERPSWD]" \
 -v "/home/base/bookstack/public/uploads:/var/www/bookstack/public/uploads" \
 -v "/home/base/bookstack/storage/uploads:/var/www/bookstack/storage/uploads" \
 -p 8080:8080 \
 --name="book-stk" \
 solidnerd/bookstack
```

* 安装mysql:5.7.xx不能用mariadb替换，否则bookstack会起不来
* 使用docker-compose安装也会出现奇怪的现象，同样的选项直接执行能起来但用docker-compose会使bookstack起不来，[参见官网](https://github.com/solidnerd/docker-bookstack)

# 事后

1. 默认用户admin@admin.com/password，登陆localhost:8080修改
2. /home/base/bookstack注意确保写入权限，否则有些上传会失败
3. 修改iptables

```shell
sudo iptables -R DOCKER 1 -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.2 --dport 3306 -j ACCEPT
sudo iptables -R DOCKER 2 -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.3 --dport 8080 -j ACCEPT
```
