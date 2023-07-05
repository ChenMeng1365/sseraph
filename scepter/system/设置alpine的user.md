
# 新增用户

v3.10.2 x86

安装后默认是root，记得新增用户

```shell
addgroup -g 10001 -S GroupName
adduser  UserName -u 20001 -D -S -s /bin/sh -G GroupName
passwd UserName
```

可以使用`su -`切换到超级用户目录

```shell
chmod 4755 /bin/busybox
```

为用户添加sudo权限

```shell
apk add sudo
visudo
```
