
# 使用crontab制定定时计划，自动执行脚本

## 安装

一般centos都自带crontab，如果没有，可以安装`yum install crontabs`

使用crond来启动服务

```shell
systemctl status crond
systemctl restart crond
```

## 配置

编辑`/etc/crontab`来配置定时计划

根据crontab中提示定制计划格式如下

```shell
分 时 日 月 周 用户名 脚本路径
```

配置完后重启crond使其生效

## 脚本配置

由于crontab执行是从它自己的路径出发，所以需要为其指定脚本解释器的路径，也就是我们常见的脚本第一行`#!/path/to/language/bin/interpreter`

有了这一行，也可以将脚本`chmod +x`，使脚本可以自动执行而不需要显式指定解释器

另外，脚本的执行位置和依赖文件位置也可能不同，如果存在文件依赖，建议脚本中指定执行位置

```shell
cd /path/to/resource/directory
./name.script zzZ
```

## 查询

[CRON时间计算](https://tool.lu/crontab/)可以用来演算计划时间设置，以免出错

文件位置`ls /var/spool/cron/`

日志位置`ls /var/log/cron*`
