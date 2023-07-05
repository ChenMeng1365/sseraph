
# 自定义路径

```shell
sudo mkdir -p /home/base/emqx
```

一般也用不上本地文件夹

# 运行mqtt

```shell
sudo docker run -d --name emqx --network 99net --network-alias emqx -p 1883:1883 -p 8080:8080 -p 8083:8083 -p 8883:8883 -p 8084:8084 -p 18083:18083 emqx/emqx
sudo docker exec -it emqx /bin/sh
```

# 端口列表

|port|desc|
|---|---|
|1883    |MQTT 协议端口|
|8883    |MQTT/SSL 端口|
|8083    |MQTT/WebSocket 端口|
|8084    |MQTT/WebSocketSSL 端口|
|8080    |HTTP API 端口|
|18083   |Dashboard 管理控制台端口|
|11883   |内部TCP监听端口|
|x369    |集群端口|

# 参数表

|field|default|attr|desc|
|---|---|---|---|
|EMQX_NAME                       |container name          |none                    |emqx node short name|
|EMQX_HOST                       |container IP            |none                    |emqx node host, IP or FQDN|
|EMQX_WAIT_TIME                  |5                       |none                    |wait time in sec before timeout|
|PLATFORM_ETC_DIR                |/opt/emqx/etc           |{{ platform_etc_dir }}  |The etc directory|
|PLATFORM_LOG_DIR                |/opt/emqx/log           |{{ platform_log_dir }}  |The log directory|
|EMQX_NODE__NAME                 |EMQX_NAME@EMQX_HOST     |node.name               |Erlang node name, name@ipaddress/host|
|EMQX_NODE__COOKIE               |emqx_dist_cookie        |node.cookie             |cookie for cluster|
|EMQX_LOG__CONSOLE               |console                 |log.console             |log console output method|
|EMQX_ALLOW_ANONYMOUS            |true                    |allow_anonymous         |allow mqtt anonymous login|
|EMQX_LISTENER__TCP__EXTERNAL    |1883                    |listener.tcp.external   |MQTT TCP port|
|EMQX_LISTENER__SSL__EXTERNAL    |8883                    |listener.ssl.external   |MQTT TCP TLS/SSL port|
|EMQX_LISTENER__WS__EXTERNAL     |8083                    |listener.ws.external    |HTTP and WebSocket port|
|EMQX_LISTENER__WSS__EXTERNAL    |8084                    |listener.wss.external   |HTTPS and WSS port|
|EMQX_LISTENER__API__MGMT        |8080                    |listener.api.mgmt       |MGMT API port|
|EMQX_MQTT__MAX_PACKET_SIZE      |64KB                    |mqtt.max_packet_size    |Max Packet Size Allowed|

注: dashboard用户名密码可改可不改，默认是admin/public，没必要保存配置文件
