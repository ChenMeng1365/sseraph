# Jupyter Notebook/Lab

## 配置jupyter

```shell
jupyter notebook --generate-config
```

启动ipython生成密码摘要

```shell
In [1]: from notebook.auth import passwd
In [2]: passwd()
Enter password:
Verify password:
Out[2]: 'sha1:74cbfeee1624:c3ee7f88275626b9e67a39168185ea3a58d2e7ee'
```

修改.jupyter

```shell
c.NotebookApp.ip='*'
c.NotebookApp.password = u'' # 粘贴摘要
c.NotebookApp.open_browser = False
c.NotebookApp.port =8888
c.NotebookApp.allow_remote_access=True
```

启动`jupyter notebook`，如果编码有问题```LANG=zn jupyter notebook```

## 安装[iruby](https://github.com/SciRuby/iruby)

### 准备工作

只有make和libtool是必须的，其他适当增减

```shell
yum install -y git-core ruby-devel ruby zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make libtool
```

### 安装zeromq

查看[zeromq官网](http://download.zeromq.org/)，下载对应版本[GitReleases](https://github.com/zeromq/zeromq4-1/releases)

```shell
wget https://github.com/zeromq/zeromq4-1/releases/download/v4.1.8/zeromq-4.1.8.tar.gz
tar -zxvf zeromq-4.1.8.tar.gz
cd zeromq-4.1.8
./configure
make && make install
```

### 安装libsodium

参看[libsodium安装文档](https://doc.libsodium.org/installation)，下载对应版本[releases](https://download.libsodium.org/libsodium/releases/)

```shell
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz
tar -zxvf libsodium-1.0.18.tar.gz
cd libsodium-1.0.18
./configure
make && make check
make install
```

### 安装ffi-rzmq

ffi-rzmq+libzmq或CZTop+CZMQ任选其一

```shell
gem install ffi-rzmq
gem install cztop
```

### 安装并注册iruby

```shell
gem install iruby --pre
iruby register --force
```

安装iruby后就可以通过`jupyter notebook`使用ruby了，也可以通过`iruby notebook`启动，二者是等效的
