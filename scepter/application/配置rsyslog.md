
# rsyslog

默认安装了rsyslog，如果没装，`yum install rsyslog`

## 双端配置

服务端配置

```shell
vi /etc/rsyslog.conf

# Provides UDP syslog reception     #若启用UDP进行传输，则取消下面两行的注释
$ModLoad imudp
$UDPServerRun 514
​
# Provides TCP syslog reception     #若启用TCP进行传输，则取消下面两行的注释
$ModLoad imtcp
$InputTCPServerRun 514
```

客户端配置

```shell
vi /etc/rsyslog.conf
​
# Provides UDP syslog reception     #若启用UDP进行传输，则取消下面两行的注释
$ModLoad imudp
$UDPServerRun 514
​
# Provides TCP syslog reception     #若启用TCP进行传输，则取消下面两行的注释
$ModLoad imtcp
$InputTCPServerRun 514
​
*.*    @192.168.1.254:514           #若启用TCP传输则使用@@，若启用UDP传输则使用@
```

之后各自重启服务

```shell
systemctl restart rsyslog
```

可以在双端验证消息的接受

```shell
# 服务端
tailf /var/log/messages 

# 客户端
logger "message test comes from client"
```

和安全相关的日志放在`/var/log/secure`

## 一些修改

可以自定义一些日志配置，避免所有配置集中在`/etc/rsyslog.conf`

```shell
vi /etc/rsyslog.d/default.conf

# 修改日志格式，让消息以客户端IP的方式展示，以免混淆
$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
$template myFormat,"%timestamp% %fromhost-ip% %syslogtag% %msg%\n"
$ActionFileDefaultTemplate myFormat

# 根据客户端IP设置目录
$template RemoteLogs,"/var/log/rsyslog/%fromhost-ip%/%fromhost-ip%_%$YEAR%-%$MONTH%-%$DAY%.log"
# 排除本地IP的日志，只记录远程主机的日志
:fromhost-ip, !isequal, "127.0.0.1" ?RemoteLogs
# 忽略之前所有的日志，远程主机日志记录完之后不再继续往下记录
& ~
```

修改日志存储目录的场合必须关闭selinux `setenforce 0`或

```shell
vi /etc/selinux/config\n\nSELINUX=disable
```

## 一些网络设备配置

* 华为ME60-X16、NE40E、NE40E-X16

```shell
info-center source default channel loghost debug state off log level warning trap level warning
info-center loghost source Loopback0
info-center loghost x.x.x.x channel loghost facility local0 language english
```

* 华为S9300

```shell
info-center source default channel loghost debug state off log level warning trap level warning
info-center loghost source LoopBack1
info-center loghost x.x.x.x transport udp source-ip x.x.x.x port xxxx channel loghost facility local0 language english
info-center loghost x.x.x.x channel loghost facility local0 language english
```

比较有意思的是华为路由器低于V600R009的版本居然是不支持改端口的，真是让人大跌眼镜，比自家交换机还憋

再就是交换机的transport是可以无视默认source单独指定source-ip和port的，对没有指定端口的配置会启用默认端口转发，指定了就按指定IP和端口转发，也是非常神奇

* 华为MA5600、MA5800

```shell
loghost add x.x.x.x SERVERNAME
# 回车
loghost activate name SERVERNAME
syslog enable alarm-event
```

OLT的日志分为命令行操作、网管操作、告警消息、组播报告。前两种是不可配置的（一定会有），告警消息配置如上，组播报告配置如下

```shell
btv
igmp log report
```

* 中兴M6000-16E、M6000-18S、ZXR8900E

```shell
syslog level warnings
syslog-server facility local3
syslog-server host x.x.x.x fport xxxx lport xxxx alarmlog
syslog-server source interface loopback1 # or syslog-server source ipv4 x.x.x.x
```

不配置fport就是默认发送514，lport自动选取

* 中兴ZXR8905

```shell
syslog-server host x.x.x.x fport xxxx lport xxxx alarmlog level warnings cmdlog debugmsg
syslog-server source x.x.x.x
syslog-server facility local3
```

* 烽火S7800

```shell
syslog server x.x.x.x PORT
syslog source x.x.x.x
syslog facility kernel
```

PORT可以不指定，默认514
