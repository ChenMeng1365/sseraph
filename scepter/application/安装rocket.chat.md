
# Rocket.chat

## [官方指导](https://docs.rocket.chat/installation/manual-installation/centos/)

安装时版本:

* Rocket.Chat 3.9.0
* OS: CentOS 7.6
* Mongodb 4.0.9
* NodeJS 12.18.4

请紧跟官方版本或保持版本和说明完全一致，尤其是node--

```shell
sudo yum -y check-update

# 更新mongo和node库
cat << EOF | sudo tee -a /etc/yum.repos.d/mongodb-org-4.0.repo
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
EOF
sudo yum install -y curl && curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -

# 安装基本工具和依赖
sudo yum install -y gcc-c++ make mongodb-org nodejs
sudo yum install -y epel-release && sudo yum install -y GraphicsMagick
sudo npm install -g inherits n && sudo n 12.18.4

# 安装rocket.chat
curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz
tar -xzf /tmp/rocket.chat.tgz -C /tmp
cd /tmp/bundle/programs/server && npm install
sudo mv /tmp/bundle /opt/Rocket.Chat

# 新增账户并授权
sudo useradd -M rocketchat && sudo usermod -L rocketchat
sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat

# 配置rocketchat服务
cat << EOF |sudo tee -a /lib/systemd/system/rocketchat.service
[Unit]
Description=The Rocket.Chat server
After=network.target remote-fs.target nss-lookup.target nginx.service mongod.service
[Service]
ExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=rocketchat
User=rocketchat
Environment=MONGO_URL=mongodb://localhost:27017/rocketchat?replicaSet=rs01 MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs01 ROOT_URL=http://localhost:3000/ PORT=3000
[Install]
WantedBy=multi-user.target
EOF
# 注意环境变量，尤其是ROOT_URL

# mongo配置与测试
sudo sed -i "s/^#  engine:/  engine: mmapv1/"  /etc/mongod.conf
sudo sed -i "s/^#replication:/replication:\n  replSetName: rs01/" /etc/mongod.conf
sudo systemctl enable mongod && sudo systemctl start mongod
mongo --eval "printjson(rs.initiate())"

# 最后启动rocket.chat，浏览ROOT_URL完成管理员配置
sudo systemctl enable rocketchat && sudo systemctl start rocketchat
```

## 优化指南

参看[这篇](https://www.cnblogs.com/DevOpsTechLab/p/13791818.html)，根据性能量力而行

```shell
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
kernel.threads-max=65535
kernel.msgmni = 16384
kernel.msgmnb = 65535
kernel.msgmax = 65535
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
kernel.shmmni = 4096
kernel.sem = 5010 641280 5010 128
net.ipv4.tcp_max_tw_buckets = 6000000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 200000
net.ipv4.tcp_no_metrics_save = 1
net.core.somaxconn = 65535
net.core.optmem_max = 10000000
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_max_syn_backlog = 655360
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes=10
net.ipv4.tcp_keepalive_intvl=2
net.ipv4.ip_local_port_range = 10000 65535
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_congestion_control=cubic
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
fs.aio-max-nr = 1024000
fs.file-max = 1024000
kernel.pid_max=327680
vm.swappiness = 0
vm.max_map_count=655360
```
