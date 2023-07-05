

### [DockerRegistry](https://hub.docker.com/_/registry)

```
sudo docker run -d -p 5000:5000 --restart always --name registry registry:2
```

```
sudo iptables -L DOCKER -n --line-number
sudo iptables -R DOCKER 12 -p tcp -m tcp -s x.x.x.x/xx -d 172.17.0.3 --dport 5000 -j ACCEPT
```

```
sudo docker pull alpine
sudo docker tag alpine localhost:5000/alpine
sudo docker push localhost:5000/alpine
```

### 

在本地服务器搭建一个docker-registry时，如果不准备为此花钱去购买一个SSL密钥，可以使用自己授权的 SSL key让registry支持HTTPS加密访问。
生成SSL证书只要两行命令，将signdomain的值换成实际域名即可：
```
signdomain=https://docker-reg.××××.com.cn:55688
openssl req -nodes \
-subj "/C=CN/ST=BeiJing/L=Dongcheng/CN=$signdomain" \
-newkey rsa:4096 -keyout $signdomain.key -out $signdomain.csr
openssl x509 -req -days 3650 -in $signdomain.csr -signkey $signdomain.key -out $signdomain.crt
```
把生成的key和crt文件配给nginx就可以提供https访问了，只是因为是没有权威认证的自签名证书，使用docker访问时会提示下面的错误：
```
docker pull docker.webmaster.me/centos:centos6
Error: Invalid registry endpoint https://docker.webmaster.me/v1/: Get https://docker.webmaster.me/v1/_ping: x509: certificate signed by unknown authority. If this private registry supports only HTTP or HTTPS with an unknown CA certificate, please add `--insecure-registry docker.webmaster.me` to the daemon's arguments. In the case of HTTPS, if you have access to the registry's CA certificate, no need for the flag; simply place the CA certificate at /etc/docker/certs.d/docker.webmaster.me/ca.crt
```
提示给出了解决方法，就是把上面生成的$signdomain.cr复制到 /etc/docker/certs.d/docker.webmaster.me/ca.crt 。按照这个方法做的话，docker pull 可以正常工作，但是如果我们的docker-registry开启了HTTP验证的话，pull之前需要先login，而实际证明docker login目前还不识别上面复制的CA证书。会提示certificate signed by unknown authority：
```
docker login docker.webmaster.me
Username: webmaster
Password:
Email: admin@webmaster.me
2014/12/27 23:41:23 Error response from daemon: Server Error: Post https://docker.webmaster.me/v1/users/: x509: certificate signed by unknown authority
```
正确的方法是，将我们生成的crt文件内容放入系统的CA bundle文件当中，使操作系统信任我们的自签名证书，docker自然也就没问题了。CentOS 6 / 7中bundle文件的位置在 /etc/pki/tls/certs/ca-bundle.crt：
```
cat $signdomain.crt >> /etc/pki/tls/certs/ca-bundle.crt
```
如果是其他Linux发行版，该文件的位置可能是下面这些，视情况而定：
```
/etc/ssl/certs/ca-certificates.crt
/etc/ssl/ca-bundle.pem
/etc/ssl/cert.pem
/usr/local/share/certs/ca-root-nss.crt
/etc/init.d/docker restart
```
修改完成后，必须重启客户端的docker服务。重启后再来docker login和docker pull ，成功了！
```
[root@localhost ~]# docker login docker.webmaster.me
Username: webmaster
Password:
Email: admin@webmaster.me
Login Succeeded
[root@localhost ~]# docker pull docker.tvmining.com/centos:centos6
Pulling repository docker.tvmining.com/centos
48a737539afd: Download complete
511136ea3c5a: Download complete
5b12ef8fd570: Download complete
70441cac1ed5: Download complete
Status: Downloaded newer image for docker.tvmining.com/centos:centos6
```