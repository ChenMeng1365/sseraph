
### 自定义目录
```
mkdir -p /home/base/mongodb/data/
```

### 运行
```
sudo docker run -itd --restart always -p 27017:27017 --network 99net --name mongodb -v /home/base/mongodb/data:/data/db --privileged=true mongo
```
如果想以指定用户启动追加选项<code>-e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=[PASSWORD]</code>

### 
进入设置管理员账号
```
docker exec -it mongo bash
mongo  admin

use admin
db.createUser(
  {
    user: "root",
    pwd: "[PASSWORD]",
    roles: [ { role: "root", db: "admin" } ]
  }
);

mongo -u root -p [PASSWORD] admin
```

增加普通用户数据库及账号
```
use [somedb]
db.createUser(
  {
    user: "[username]",
    pwd: "[password]",
    roles: [ { role: "readWrite", db: "test" } ]
  }
);

mongo -u [username] -p [password] --authenticationDatabase [somedb]
```


