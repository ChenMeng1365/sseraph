
# 安装

安装前可查询是否安装过ntp服务

```shell
rpm -q ntprpm -q ntp
```

安装并设置为开机自启动

```shell
yum -y install ntp
systemctl enable ntpd
systemctl start ntpd
```

时钟源可参照[pool.ntp.org](https://www.pool.ntp.org/zone/cn)和[ntp.org.cn](http://www.ntp.org.cn/pool.php#china)来设置

# 服务端

`vi /etc/ntp.conf`

```shell
# 新增ntp服务网段
restrict xxx.xxx.xxx.0 mask 255.255.255.0 nomodify notrap

# 注销系统默认时钟源
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst

# 新增指定时钟源
server 0.cn.pool.ntp.org
server 1.cn.pool.ntp.org
server 2.cn.pool.ntp.org
server 3.cn.pool.ntp.org

restrict 0.cn.pool.ntp.org nomodify notrap noquery
restrict 1.cn.pool.ntp.org nomodify notrap noquery
restrict 2.cn.pool.ntp.org nomodify notrap noquery
restrict 3.cn.pool.ntp.org nomodify notrap noquery

# 新增本地时钟源
server 127.0.0.1 # local clock
fudge 127.0.0.1 stratum 10
```

# 客户端

`vi /etc/ntp.conf`

```shell
# 注销系统默认时钟源
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst

# 使用指定时钟源
server xxx.xxx.xxx.xxx
restrict xxx.xxx.xxx.xxx nomodify notrap noquery

# 新增本地时钟源
server 127.0.0.1 # local clock
fudge 127.0.0.1 stratum 10
```

# 查询

设置完成后修改ACL并重启ntp服务

```shell
systemctl restart ntpd
```

使用`ntpdate -u SERVER`和上游服务器同步

使用`timedatectl`检测当前时区，中国是东八时区，所以需要加8小时`timedatectl set-timezone Asia/Shanghai`

使用`ntpq -p`查询网络中时间服务器状态

使用`ntpstat`查询时钟同步状态

# 手动同步时间

```shell
# 格式化输出时间
date "+%Y-%m-%d %H:%M:%S"

# 设置时间
date -s "2016-09-10 14:24:34"
```
