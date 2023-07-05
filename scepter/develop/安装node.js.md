# 安装node.js

## 安装node

先去官网下载bin包

```shell
cd /usr/local
wget https://npm.taobao.org/mirrors/node/v14.9.0/node-v14.9.0-linux-x64.tar.xz
```

解压并作为根目录

```shell
xz -d node-v9.3.0-linux-x64.tar.xz
tar -xf node-v9.3.0-linux-x64.tar
mv node-v9.3.0-linux-x64 node
```

将根目录bin文件加入系统路径

```shell
ln -s /usr/local/node/bin/node /usr/local/bin/node
ln -s /usr/local/node/bin/npm /usr/local/bin/npm
ln -s /usr/local/node/bin/npm /usr/local/bin/npx
```

验证

```shell
node -v
npm -v
npx -v
```

## 设置npm

```shell
npm config get registry
npm config set registry https://registry.npm.taobao.org
```

国内建议使用cnpm

```shell
npm install -g cnpm --registry=https://registry.npm.taobao.org
cnpm install xxx
```

## 离线安装npm包

先在线下载，再离线安装
建立本地文件夹，在线下载安装包

```shell
cd LocalRepo
npm install package_name --global-style
```

打包后传到离线机器上
在目标机器上，拷贝本地文件夹，执行

```shell
cd OfflineDir
npm install LocalRepo/ -g
```

## 其他问题拾遗

* electron

```shell
cnpm init
cnpm install electron --save-dev
npx electron -v
.\node_modules\.bin\electron . # win下注意斜杠顺序
```
