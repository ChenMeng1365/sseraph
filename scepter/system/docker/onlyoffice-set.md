
# [onlyoffice/documentserver-ie](https://hub.docker.com/r/onlyoffice/documentserver-ie)

注意是Integration Edition，和普通版还是有区别

```shell
docker pull onlyoffice/documentserver-ie:5.6
```

```shell
mkdir /home/base/onlyoffice/*

sudo docker run -i -t -d --name onlyoffice -p 80:80 -p 443:443 \ # 80/443
  -v /home/base/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
  -v /home/base/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
  -v /home/base/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \
  -v /home/base/onlyoffice/DocumentServer/db:/var/lib/postgresql \ # db optional
  onlyoffice/documentserver-ie:5.6
```

生成SSL证书

```shell
cd /home/base/onlyoffice/DocumentServer/data/certs
openssl genrsa -out onlyoffice.key 2048
openssl req -new -key onlyoffice.key -out onlyoffice.csr
openssl x509 -req -days 3650 -in onlyoffice.csr -signkey onlyoffice.key -out onlyoffice.crt
```
