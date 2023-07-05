
# command

```shell
curl -o /dev/null -s -w "参数" "资源路径"
curl -o /dev/null -s -w "参数" -L "链接"
```

# usage

```shell
参数 ::= http_code: %{http_code}\nhttp_connect: %{http_connect}\ncontent_type: %{content_type}\ntime_dns: %{time_namelookup}\ntime_redirect: %{time_redirect}\ntime_pretransfer: %{time_pretransfer}\ntime_connect: %{time_connect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\nspeed_download: %{speed_download}\n
```

# arguments

url_effective 最后获取的URL。

http_code 上一次HTTP(S)或FTP(S)操作返回的响应码。在7.18.2版加入的response_code显示同样的信息。

http_connect 在最后一次对cURL的CONNECT请求的响应(从代理)中发现的数值代码。 （在7.12.4版加入)

time_total 全部操作耗费的时间，单位为秒。精确到毫秒。

time_namelookup 从开始到域名解析完成耗费的时间，单位为秒。

time_connect TCP连接远程主机(或代理服务器)所耗时间，单位为秒。

time_appconnect SSL/SSH/等与远程主机连接/握手完成花费的时间，单位为秒。(在7.19.0 版加入)

time_pretransfer 从开始到文件将要传输前花费的时间，单位为秒。包括指定的协议所有预传输命令和negotiations。

time_redirect 所有重定向步骤的时间，包域名解析、连接、预传输和最后事务开始前的传输，单位为秒。time_redirect显示多重重定向的完整执行时间。(在7.12.3版加入 )

time_starttransfer  从开始到第一个字节将被传输前耗费的时间，单位为秒。这包括time_pretransfer和服务器需要的运算结果的时间。

size_download下载的总字节数。

size_upload上传的总字节数。

size_header 下载的header的总字节数。

size_request 发送的HTTP请求的总字节数。

speed_download curl成功下载的平均下载速度。

speed_upload curl成功上传的平均上传速度。
