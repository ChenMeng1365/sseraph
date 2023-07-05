
# 安装

```shell
yum update
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://download.docker.com/linux/centos/docker-ce.repo # 中央仓库
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo # 阿里仓库
yum list docker-ce --showduplicates | sort -r
yum install docker-ce-版本号
systemctl start docker
systemctl enable docke
docker version
```

# 使用

```shell
docker ps # 查看当前正在运行的容器
docker ps -a # 查看所有容器的状态
docker start/stop id/name # 启动/停止某个容器
docker attach id # 进入某个容器(使用exit退出后容器也跟着停止运行)
docker exec -ti id # 启动一个伪终端以交互式的方式进入某个容器（使用exit退出后容器不停止运行）
docker images # 查看本地镜像
docker rm id/name # 删除某个容器
docker rmi id/name # 删除某个镜像
docker run --name xxx -ti image /bin/bash # 复制image并且重命名为xxx运行，然后以伪终端交互式方式进入容器，运行bash
docker build -t image:x.x . # 通过当前目录下的Dockerfile创建一个名为image，版本为x.x的镜像
```

导入/导出镜像, 加载/保存容器

```shell
docker save -o <保存路径> <镜像名称:标签>
docker load --input <保存路径>

docker export <容器名> > <保存路径>
docker import <文件路径>  <容器名>
```

查看容器分配IP

```shell
#!/bin/bash
docker inspect --format='{{.NetworkSettings.IPAddress}}' $1
```

# 配置

## 添加用户组权限

```shell
sudo usermod -aG docker USERNAME
sudo systemctl restart docker
sudo chmod a+rw /var/run/docker.sock
```

## 修改源镜像地址

遇到拉不动镜像的情况，诸如`Error response from daemon: Get https://registry-1.docker.io/v2/library/ubuntu/manifests/2.04: Get https://auth.docker.io/token?scope=repository%3Alibrary%2Fubuntu%3Apull&serviceregistry.docker.io: net/http: TLS handshake timeout`

```shell
dig @114.114.114.114 registry-1.docker.io

# 根据查到的IP追加hosts
vi /etc/hosts
18.232.227.119 registry-1.docker.io
```

## 修改存储路径

编辑`/usr/lib/systemd/system/docker.service`, 对`execStart`增加`--graph`选项指定路径

```shell
systemctl daemon-reload
systemctl restart docker
```

## 创建虚拟网络

```shell
sudo docker network ls
sudo docker network create some-network
```

新建容器时通过`--network`指定网络,`--network-alias`来指定网络中使用的域名

## 创建虚拟网桥

(1) 删除默认网桥

```shell
sudo service docker stop
sudo ip link set dev docker0 down
sudo brctl delbr docker0
sudo iptables -t nat -F POSTROUTING
```

(2) 创建新的网桥

```shell
sudo brctl addbr bridge0
sudo ip addr add 10.1.5.1/24 dev bridge0
sudo ip link set dev bridge0 up
```

(3) 将新网桥写入配置文件

```shell
echo 'DOCKER_OPTS="-b=bridge0"' >> /etc/default/docker
sudo service docker start
```

## 使用docker-compose

```shell
curl -L https://github.com/docker/compose/releases/download/1.27.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```
