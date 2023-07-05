

nodejs版本不要超过8.x

安装nodejs

```
mkdir -p /opt/nodejs
yum install wget
wget https://nodejs.org/dist/latest-v8.x/node-v8.17.0-linux-x64.tar.gz
tar -zxvf node-v8.17.0-linux-x64.tar.gz
mv node-v8.17.0-linux-x64 /opt/nodejs
ln -s /opt/nodejs/node-v8.17.0-linux-x64/bin/node /usr/local/bin/node
ln -s /opt/nodejs/node-v8.17.0-linux-x64/bin/npm /usr/local/bin/npm

npm install -g cnpm --registry=https://registry.npm.taobao.org
npm config set registry https://registry.npm.taobao.org
```

安装redis

```
wget http://download.redis.io/releases/redis-4.0.1.tar.gz
tar -zxvf redis-4.0.1.tar.gz
mv redis-4.0.1 /opt/redis
cd /opt/redis/redis-4.0.1
yum install -y gcc
make
make install 

redis-server > redis-running.log &
redis-cli
redis-cli shutdown
```

安装mongodb

```
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.0.tgz
tar -zxvf mongodb-linux-x86_64-4.0.0.tgz
mv mongodb-linux-x86_64-4.0.0 /opt/mongodb
yum install cyrus-sasl cyrus-sasl-gssapi cyrus-sasl-plain krb5-libs libcurl libpcap lm_sensors-libs net-snmp net-snmp-agent-libs openldap openssl rpm-libs tcp_wrappers-libs

vi /etc/profile
加入以下内容
# MongoDB_HOME
export MongoDB_HOME=/opt/mongodb/mongodb-linux-x86_64-4.0.0
export PATH=$MongoDB_HOME/bin:$PATH

mkdir -p /data/db

mongod > mongo-running.log &
```

安装和配置easy-mock

```
yum install git
git clone https://github.com/easy-mock/easy-mock.git
cd easy-mock && npm install

vi config/default.json
{
  "port": 7300,
  "host": "x.x.x.x",
  "pageSize": 30,
  "proxy": false,
  "db": "mongodb://localhost/easy-mock",
  "unsplashClientId": "",
  "redis": {
    "keyPrefix": "[Easy Mock]",
    "port": 6379,
    "host": "0.0.0.0",
    "password": "",
    "db": 0
  },
  "blackList": {
    "projects": [], // projectId，例："5a4495e16ef711102113e500"
    "ips": [] // ip，例："127.0.0.1"
  },
  "rateLimit": { // https://github.com/koajs/ratelimit
    "max": 1000,
    "duration": 1000
  },
  "jwt": {
    "expire": "14 days",
    "secret": "shared-secret"
  },
  "upload": {
    "types": [".jpg", ".jpeg", ".png", ".gif", ".json", ".yml", ".yaml"],
    "size": 5242880,
    "dir": "../public/upload",
    "expire": {
      "types": [".json", ".yml", ".yaml"],
      "day": -1
    }
  },
  "ldap": {
    "server": "", // 设置 server 代表启用 LDAP 登录。例："ldap://localhost:389" 或 "ldaps://localhost:389"（使用 SSL）
    "bindDN": "", // 用户名，例："cn=admin,dc=example,dc=com"
    "password": "",
    "filter": {
      "base": "", // 查询用户的路径，例："dc=example,dc=com"
      "attributeName": "" // 查询字段，例："mail"
    }
  },
  "fe": {
    "copyright": "",
    "storageNamespace": "easy-mock_",
    "timeout": 25000,
    "publicPath": "/dist/"
  }
}

保持mongo和redis运行状态下启动
npm run dev
npm run build
或者
npm install pm2 -g
ln -s /opt/nodejs/node-v8.17.0-linux-x64/bin/pm2 /usr/local/bin
pm2 start app.js
```
