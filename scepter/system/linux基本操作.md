
# L系基本操作

## 系统基本信息

```shell
cat /etc/redhat-release
uname -a
hostnamectl
```

## 系统上线时间

```shell
uptime
```

## 在线用户

```shell
who
who -Hu
```

## 用户账号信息

```shell
grep sh$ /etc/passwd
```

## 硬件/虚拟机供应商信息

```shell
dmidecode -s system-manufacturer
dmidecode -s system-product-name
lshw -c system | grep product | head -1
cat /sys/class/dmi/id/product_name
cat /sys/class/dmi/id/sys_vendor
```

## 硬件性能信息

```shell
lscpu or cat /proc/cpuinfo
lsmem or cat /proc/meminfo
ifconfig -a
ethtool <devname>
lshw
lspci
dmidecode
```

## 软件安装信息

RH系

```shell
rpm -qa
rpm -qa | grep <pkgname>
rpm -qi <pkgname>
yum repolist
yum repoinfo
yum install <pkgname>
ls -l /etc/yum.repos.d/
```

## 进程服务信息

```shell
pstree -pa 1
ps -ef
ps auxf
systemctl
```

## 网络连接信息

```shell
netstat -tulpn
netstat -anp
lsof -i
ss
iptables -L -n
cat /etc/resolv.conf
```

## 内核信息

```shell
uname -r
cat /proc/cmdline
lsmod
modinfo <module>
sysctl -a
cat /boot/grub2/grub.cfg
```

## 日志信息

```shell
dmesg
tail -f /var/log/messages
journalctl
```
