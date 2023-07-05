
# 安装说明

参看对应git项目[leanote](https://github.com/leanote/leanote/wiki/Leanote-%E4%BA%8C%E8%BF%9B%E5%88%B6%E7%89%88%E8%AF%A6%E7%BB%86%E5%AE%89%E8%A3%85%E6%95%99%E7%A8%8B----Mac-and-Linux)

配置前准备：

* 安装golang
* 安装mongodb，配置路径
* 下载leanote安装包并解压

# 配置过程

启动mongo前先初始化leanote数据库

```shell
mongorestore -h localhost -d leanote --dir /home/xxx/workspace/srv/leanote/mongodb_backup/leanote_install_data/
```

启动mongo加载leanote数据库路径

```shell
mongod --dbpath /home/xxx/workspace/srv/mongo &
```

修改数据库管理员和试用账号密码

```shell
mongo
use leanote
db.users.find()
db.users.update( {"_id" : ObjectId("[admin-user-id]")},  {$set:{ "Pwd" : "[password-md5]"}} )
db.users.update( {"_id" : ObjectId("[demo-user-id]")},  {$set:{ "Pwd" : "[password-md5]"}} )
```

修改配置文件,其中app-secret根据官方建议应修改

```shell
cd /home/xxx/workspace/srv/leanote
vi conf/app.conf

http.addr = 0.0.0.0
http.port = 8080 # 地址和端口根据需要更换
site.url = ... # 这是附件生成的域名，用于在博客中展示附件的链接

db.host = 127.0.0.1
db.port = 27017
db.dbname = leanote
db.username = ...
db.password = ... # 根据选用的数据库不同，也可以选用非本地的

app.secret= ... # 根据官方安全建议修改，绝不能使用默认的
```

启动leanote

```shell
cd bin
bash run.sh &
```
