
# 目录

- [安装](#安装)
- [使用](#使用)
- [配置](#配置)

# 安装

## 准备

nginx编译依赖于gcc、g++、zlib、pcre、openssl，其中zlib和pcre还需要devel版本才能正常编译

```shell
yum update -y
yum groupinstall -y "Developement Tools"
yum install -y zlib-devel pcre-devel
```

ubuntu侧直接安装

```shell
sudo apt install nginx
```

## 常规

登陆[nginx官网](nginx.org)下载版本，一般选stable版

```shell
cd /usr/local
wget http://nginx.org/download/nginx-1.16.1.tar.gz
tar -zxvf nginx-1.16.1.tar.gz
cd nginx-1.16.1
./configure # 默认选项编译
make && make install
```

一般使用默认选项安装配置路径如下

```repl
Configuration summary
  + using system PCRE library
  + OpenSSL library is not used
  + using system zlib library

  nginx path prefix: "/usr/local/nginx"
  nginx binary file: "/usr/local/nginx/sbin/nginx"
  nginx modules path: "/usr/local/nginx/modules"
  nginx configuration prefix: "/usr/local/nginx/conf"
  nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
  nginx pid file: "/usr/local/nginx/logs/nginx.pid"
  nginx error log file: "/usr/local/nginx/logs/error.log"
  nginx http access log file: "/usr/local/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"
```

## SSL

有些场合需要ssl加密，在安装的时候，编译需要追加选项

```shell
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
make # 不要make install
```

如果是之前已经安装过了，重新编译后生成的执行文件为objs/nginx，将其拷贝替换/usr/local/nginx/sbin/nginx
查看nginx详细信息会有配置参数

```repl
/usr/local/nginx/sbin/nginx -V

nginx version: nginx/1.19.2
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-39) (GCC)
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
```

生成自签证书的方法

```shell
sudo openssl req -new -newkey rsa:2048 -sha256 -nodes -out sseraph.csr -keyout sseraph.key -subj "/C=CN/ST=Hubei/L=Xiaogan/O=Seraph S./OU=Web Security/CN=seraph.com"
sudo openssl x509 -req -days 3650 -in sseraph.csr -signkey sseraph.key -out sseraph.crt

# Diffie–Hellman密钥交换
sudo openssl dhparam -out dhparam.pem 4096 # 2048
```

配置https服务

```shell
cat EOF<< >> conf.d/https.conf
server {
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on;
    server_name sseraph.com;
    ssl on;
    ssl_certificate     /etc/nginx/ssl/sseraph.crt; // 自签证书
    ssl_certificate_key /etc/nginx/ssl/sseraph.key; // 私钥

    // 全站加密且强制https
    add_header Strict-Transport-Security max-age=63072000;
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;

    // http跳转https
    listen 80;
    listen [::]:80 ssl ipv6only=on;
    return 301 https://sseraph.com$request_uri;

    // 采用Diffie–Hellman密钥交换
    ssl_dhparam /etc/nginx/certs/dhparam.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4";
    keepalive_timeout 70;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.4.4 8.8.8.8 valid=300s;
    resolver_timeout 10s;
}
EOF
```

## 验证

检查版本

```shell
/usr/local/nginx/sbin/nginx -v
```

# 使用

直接运行`/usr/local/nginx/sbin/nginx`可启动服务（后台执行，不需要&），也可以为它配置路径

```shell
export PATH=$PATH:/usr/local/nginx/sbin
```

或者为其增加软链接

```shell
ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx
```

这样可以直接使用`nginx`命令

或者为系统添加服务

```shell
vim /lib/systemd/system/nginx.service

[Unit]
Description=nginx
After=network.target
  
[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx reload
ExecStop=/usr/local/nginx/sbin/nginx quit
PrivateTmp=true
  
[Install]
WantedBy=multi-user.target

systemctl enable nginx.service
```

查看进程和端口状态

```shell
ps -ef | grep nginx
netstat -ntulp | grep 80
systemctl status nginx
```

关闭的方法是`nginx -s stop`，或使用kill（从容停止`kill -QUIT 主进程`，快速停止`kill -TERM 主进程`）

重启的方法是`nginx -s reload`

注册了服务用systemctl的restart、stop、enable操作也可以，但是以systemctl方式启动服务就不要和其他方式混用，否则会失败

# 配置

配置文件放在`/usr/local/nginx/conf`中，默认加载`/usr/local/nginx/conf/nginx.conf`，加载不同的配置文件只需`nginx -c CONFIG_PATH`指定路径即可

可以使用`nginx -t -c CONFIG_PATH`来测试配置文件是否编写正确

ubuntu侧默认安装配置在`/etc/nginx/nginx.conf`下, 子配置目录为`/etc/nginx/conf.d`

## 反向代理

### 1.域名转端口

访问域名[node100.com](http://node100.com)时就会转发到本地的8080端口上

```nginx
server{
  listen 80;
  server_name  node100.com;
  index  index.php index.html index.htm;

  location / {
    proxy_pass  http://127.0.0.1:8080; # 转发规则
    proxy_set_header Host $proxy_host; # 修改转发请求头，让8080端口的应用可以受到真实的请求
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

### 2.域名转域名

访问域名[node100.com](http://node100.com)时就会转发到[node101.com](http://node101.com)上

```nginx
server{
  listen 80;
  server_name  node100.com;
  index  index.php index.html index.htm;

  location / {
    proxy_pass  http://node101.com;
    proxy_set_header Host $proxy_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

### 3.端口转端口

访问192.168.0.100的80端口时就会转发到本地的8080端口上

```nginx
server{
  listen 80;
  server_name 192.168.0.100;
  index  index.php index.html index.htm;

  location / {
    proxy_pass  http://192.168.0.100:8080;
    proxy_set_header Host $proxy_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

### ※ 带/和不带/

访问a.a.a.a/path/rest会转到b.b.b.b/rest

```nginx
server{
  server_name a.a.a.a;
  location /path/ {
    proxy_pass  http://b.b.b.b/;
  }
}
```

访问a.a.a.a/path/rest会转到b.b.b.b/path/rest

```nginx
server{
  server_name a.a.a.a;
  location /path/ {
    proxy_pass  http://b.b.b.b;
  }
}
```

总结：带/表示接口对象是绝对路径，而代理对象本身是相对路径；不带/表示接口对象和代理对象都是相对路径，二者巡径一致

## 优化

### 限制访问

```shell
http {
  # 限制IP访问频率
  limit_conn_zone $binary_remote_addr zone=perip:1m;
  limit_conn_zone $server_name zone=perserver:1m;

  server {
    # 反爬虫
    if ($http_user_agent ~* (Scrapy|Curl|HttpClient)){
      return 403;
    }

    # 限制IP连接数量
    limit_conn perip 4;
    limit_conn perserver 20;
    limit_rate 100k;
  }
}
```
