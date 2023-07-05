
# 设置Debian拾遗

注意debian默认的vi是经典习惯的，用HJKL操作方向，AIOX也有差异，如果不习惯，第一件事就是安装vim，之后vi的操作习惯就正常了，也可以直接使用命令vim

## 权限及远程登陆限制

如果默认在root外新增了一个用户，它没有sudo权限，你会发现连上普通账号后什么命令都没有
而最小安装下sudo这个工具也是没有安装的，所以需要安装并配置

```shell
$apt-get install sudo
$vi /etc/sudoers

username ALL=(ALL) ALL

$chmod 0440 /etc/sudoers
```

之后就可以正常使用sudo了

另一方面，要限制ssh登陆root账号

```shell
$vi /etc/ssh/sshd_config

PermitRootLogin no

$service sshd restart # 或/etc/init.d/ssh restart
```

## 设置网络

```shell
$vi /etc/netowrk/interfaces

auto eth0
iface lo inet loopback
allow-hotplug eth0
iface eth0 inet static # static或dhcp，使用dhcp下面的地址均可以不设置
address x.x.x.x
netmask x.x.x.x
gateway x.x.x.x
broadcase x.x.x.x # 广播地址可省略

$vi /etc/resolv.conf

nameserver x.x.x.x #首选dns
nameserver x.x.x.x #备用dns

$service networking restart # 或systemctl restart networking
```

## 设置防火墙/访问控制列表

```shell
# 如果没安装防火墙，先安装，一般都会有
apt search iptables
apt-get install iptables

# 清空配置
iptables -F
iptables -X
iptables -Z
# 过滤配置
iptables -P INPUT DROP
iptables -P OUTPUT -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7 # 记录接收数据包被拒绝（log-level=7）的日志，最高记录频率为5条/分钟，日志通过dmesg或syslog查看
iptables -A OUTPUT -p udp -j REJECT --reject-with icmp-port-unreachable # OUTPUT建议有条件地屏蔽，不然每个应用都要设置比较麻烦
iptables -A INPUT -j REJECT --reject-with icmp-port-unreachable
iptables -A FORWARD -j REJECT --reject-with icmp-port-unreachable

# 保存及恢复配置，写入文件后四表五链会自动排列
iptables-save > /etc/iptables
iptables-restore < /etc/iptables
# 注意和RH系iptables-services有点不太一样的地方是，iptables没有指定默认加载位置，你可以将其放在/etc/iptables或其他位置开机后加载，或者写入/etc/init.d/或/etc/network/if-pre-up.d/启动脚本
```

`-m state --state <状态>`的几种状态：

* INVALID：无效的封包，例如数据破损的封包状态
* ESTABLISHED：已经联机成功的联机状态
* NEW：想要新建立联机的封包状态
* RELATED：表示这个封包是与主机发送出去的封包有关， 可能是响应封包或者是联机成功之后的消息封包

## 设置软件镜像源

```shell
$cp /etc/apt/sources.list /etc/apt/sources.list_bak

# 方法一：直接替换源地址
$sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# 方法二：编辑添加源地址
$vi /etc/apt/sources.list

deb http://mirrors.ustc.edu.cn/debian stable main contrib non-free
# deb-src http://mirrors.ustc.edu.cn/debian stable main contrib non-free
deb http://mirrors.ustc.edu.cn/debian stable-updates main contrib non-free
# deb-src http://mirrors.ustc.edu.cn/debian stable-updates main contrib non-free

# deb http://mirrors.ustc.edu.cn/debian stable-proposed-updates main contrib non-free
# deb-src http://mirrors.ustc.edu.cn/debian stable-proposed-updates main contrib non-free

$sudo apt-get update
```

常用国内源：

* 清华大学： mirrors.tuna.tsinghua.edu.cn
* 电子科技大学： mirrors.ustc.edu.cn
* 阿里云： mirrors.cloud.aliyuncs.com
* 华为： mirrors.huaweicloud.com
* 网易： mirrors.163.com

※ 对于那些没有sudo vi、不更新源、又不想`--user root`进入docker镜像安装的话，可直接`echo >`刷入镜像源的配置；或用`sed -i`、`docker cp`来做替换

```shell
$cp /etc/apt/sources.list /etc/apt/sources.list.bak
$echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list
$echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
$echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
$echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list
$echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
$echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list
$echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
$echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
$echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list
$echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
```
