
# telnet

偶尔还会使用到telnet，没装telnet可以安装

```shell
rpm -qa telnet-server
rpm -qa xinetd
```

```shell
yum install telnet-server.x86_64
yum install telnet.x86_64
yum install xinetd.x86_64
```

```shell
systemctl enable xinetd.service
systemctl enable telnet.socket
systemctl start telnet.socket
systemctl start xinetd
```
