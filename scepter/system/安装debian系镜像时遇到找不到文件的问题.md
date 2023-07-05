
# debian系问题

出现过的系统有：
- debian
- ubuntu
- kali
- alpine

# 加载时发现缺少某个文件

```shell
Failed to load ldlinux.c32
Boot failed: please change disks and press a key to continue.
```

# 原因和解决

这是因为新版镜像压制方式变了，使用UltraISO时，写入方式换为RAW写入。
