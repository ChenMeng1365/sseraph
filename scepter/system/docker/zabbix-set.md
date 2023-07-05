
### To be continued
```
sudo docker run --name zabbix-server-mysql \
                --network testnet --network-alias zabbix-server-mysql \
                -p 10051:10051 \
                -e DB_SERVER_HOST="mariadb" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="[PASSWORD]" \
                -d zabbix/zabbix-server-mysql
```

```
sudo docker run --name zabbix-web-nginx-mysql \
                --network testnet --network-alias zabbix-web-nginx-mysql \
                -e DB_SERVER_HOST="mariadb" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="[PASSWORD]" \
                -e ZBX_SERVER_HOST="zabbix-server-mysql" -e PHP_TZ="Asia/Shanghai" \
                -p 80:80 -p 443:443 \
                -d zabbix/zabbix-web-nginx-mysql
```

先确保数据库设置好
```
# mysql -uroot -p
# password
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
mysql> quit;
```

下载源码/安装包，找到create.sql.gz脚本导入数据库
```
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
```
如果是远程安装 mysql -hx.x.x.x -uuser -ppasswd

修改字体库
```
sudo docker  cp ./STXIHEI.TTF   e7d8b3c3c6a8:/usr/share/zabbix/assets/fonts/
sudo docker exec -it  zabbix-web-nginx-mysql /bin/bash
chmod 777 STXIHEI.TTF
vi /usr/share/zabbix/include/defines.inc.php
define('ZBX_GRAPH_FONT_NAME',           'STXIHEI');
```

```
sudo docker run --name zabbix-agent \
                --network testnet --network-alias node99 \
                -e ZBX_HOSTNAME="node99" -e ZBX_SERVER_HOST="zabbix-server-mysql" \
                -p 10050:10050 \
                -d zabbix/zabbix-agent
```

```
sudo docker exec -it zabbix-agent /bin/bash
vi /etc/zabbix/zabbix_agentd.conf
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log  #错误日志
LogFileSize=0
ListenPort=10050  #启动监听端口
StartAgents=3 #被动模式下选择，主动模式则为0
ListenIP=0.0.0.0 #监听所有IP
Server=10.27.146.250 #被动模式下必填，将zabbix-server端的ip填入
#ServerActive=10.27.146.250 #主动模式下填写
Hostname=Api1Bearead #本机的hostname，此值必须与zabbix的网页上创建的主机名一致即可
Include=/etc/zabbix/zabbix_agentd.d/
```
