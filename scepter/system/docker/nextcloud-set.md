
# 安装并启动服务

```shell
docker pull nextcloud
docker run -itd --restart always -p 80:80  --name nextcloud -v /home/nextcloud:/var/www/html nextcloud

docker pull onlyoffice/documentserver
docker run -itd --restart always -p 80:80 --name onlydocument \
    -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  onlyoffice/documentserver

docker logs -f onlydocument
```

最好将documentserver和nextcloud安装在不同机器上，同一机器上运行nginx可能会报错

此外保险起见也关掉selinux和firewalld

```shell
setenforce 0
systemctl disable firewalld
systemctl restart iptables
systemctl restart docker
```

记得为documentserver添加访问限制，只让nextcloud访问

```shell
iptables -R DOCKER x -p tcp -m tcp -s x.x.x.x/xx -d 172.17.0.2 --dport 80 -j ACCEPT
```

另一种文档协作的服务是用onlyoffice自家的communityserver

```shell
docker pull onlyoffice/communityserver
docker run -itd --restart always -p 80:80 --name onlycommunity \
    -v /home/onlyoffice/CommunityServer/logs:/var/log/onlyoffice  \
    -v /home/onlyoffice/CommunityServer/data:/var/www/onlyoffice/Data  \
    -v /home/onlyoffice/CommunityServer/mysql:/var/lib/mysql  onlyoffice/communityserver
```

不过我没成功启动过，一直卡在加载界面

## 添加onlyoffice插件

nextcloud增加onlyoffice在线编辑功能可以参看这篇[文档](https://api.onlyoffice.com/editors/nextcloud)

在nextcloud管理员界面点击"+应用"，更新插件列表

在个性化定制中，选择"Office&text"，搜索onlyoffice，找到插件并安装

如果打不开，可以从[nextcloud商店的onlyoffice插件](https://apps.nextcloud.com/apps/onlyoffice)下载插件到nextcloud的apps目录，这里是/var/www/html

```shell
cd apps
curl -L https://github.com/ONLYOFFICE/onlyoffice-nextcloud/releases/download/v4.1.4/onlyoffice.tar.gz -o onlyoffice.tar.gz
tar -zxvf onlyoffice.tar.gz
# 或者 git clone https://github.com/ONLYOFFICE/onlyoffice-nextcloud.git onlyoffice
chown -R www-data:www-data onlyoffice
```

如果使用的是https服务，那么还需要在nextcloud中关闭onlyoffice认证

```shell
'onlyoffice' => array (
    'verify_peer_off' => true
)
```

重新点击管理员界面的"+应用"，更新插件列表，在"已禁用的应用"中激活Onlyoffice

然后进入"设置">"管理">"ONLYOFFICE"

更新前请先停止nextcloud和onlyoffice进程

测试完成后，弹出common settings，将想要在线编辑的格式勾选上，save

## 添加collabora插件

仍旧单独找一台机器，启动collabora/code平台

```shell
docker pull collabora/code
docker run -t -d -p 0.0.0.0:9980:9980 --name collabora -e 'domain=nextcloud\\.numeron\\.net\|nextcloud\\.service\\.com' -e "username=admin" -e "password=123456" --restart always --cap-add MKNOD collabora/code
```

启动后还要单独启动nginx服务

```shell
systemctl restart nginx
```

nginx要在collabora启动完成后再启动，其配置修改如下：

```conf
server {
    listen       443 ssl;

    server_name   collabora.numeron.net;
    ssl on;
    ssl_certificate /usr/local/nginx/ssl/server.crt;
    ssl_certificate_key /usr/local/nginx/ssl/server.key;

    location ^~ /loleaflet {
        proxy_pass https://localhost:9980;
        proxy_set_header Host $http_host;
    }

    location ^~ /hosting/discovery {
        proxy_pass https://localhost:9980;
        proxy_set_header Host $http_host;
    }

    location ^~ /lool {
        proxy_pass https://localhost:9980;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $http_host;
    }
}
```

其中证书可以自己生成，放在指定目录下

```shell
openssl req -new -x509 -nodes -out server.crt -keyout server.key
```

首次访问collabora平台，会要求输入用户名和密码

```url
https://collabora.numeron.net/loleaflet/dist/admin/admin.html
```

在此可以监控文件和用户

在nextcloud应用中添加collabora插件，方法可以参照[添加onlyoffice插件](#添加onlyoffice插件)

添加后在"配置">"在线协作"中设置collabora的URL

### 其他常用插件

* analytics-2.0.0

* announcementcenter-3.7.0

* circles-0.18.3

* deck-0.8.0

* drawio-v0.9.5

* social-login-v2.4.4-release

* spreed-8.0.5(chat)

注意nextcloud版本和对应插件版本

### 其他问题

选项：默认使用SQLite数据库，以后用户多了可试下mariadb或postgres

问题：collabora能正常配置，但在线协作出现异常
