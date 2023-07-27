# 安装

## 前置准备

```shell
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make
```

## 安装过程

```shell
# 源码安装
$wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2rc2.tar.xz
$mkdir /usr/local/python3
$tar -xvJf  Python-3.8.2rc2.tar.xz
$cd Python-3.8.2rc2
$./configure --prefix=/usr/local/python3
$make && make install
$ln -s /usr/local/python3/bin/python3 /usr/bin/python3
$ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
```

## 问题集

### 升级pip和setuptools

```shell
$python3 -m pip install -U pip
$python3 -m pip install -U setuptools
```

### 修改pip源

```shell
# 临时源
$pip install package_name -i https://pypi.tuna.tsinghua.edu.cn/simple

# 命令行变量
$pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 配置文件
$cd ~
$mkdir .pip
$vi pip.conf

[global]
index-url=https://pypi.tuna.tsinghua.edu.cn/simple
timeout = 6000

[install]
trusted-host=pypi.tuna.tsinghua.edu.cn
disable-pip-version-check = true
```

### 修改anaconda源

windows下

```shell
> conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
> conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge 
> conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/
> conda config --set show_channel_urls yes

> conda config --show channels
```

linux下

```shell
$vi ~/.condarc

channels:
  - https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
  - https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - defaults
show_channel_urls: true
```

若仍源不生效，就把defaults也去掉

### pip安装时出现SSL错误

```shell
WARNING: pip is configured with locations that require TLS/SSL, however the ssl module in Python is not available.
```

有些时候即使安装了openssl模块依然会弹出这个错误, 这时候需要在编译时增加openssl选项

```shell
./configure --prefix=/usr/local/python3 --with-openssl=/usr/local/openssl --with-openssl-rpath=auto
make -j && make install
```

不能确定openssl目录的场合, `whereis openssl`查找, `--with-openssl`关联的是openssl的安装路径而不是执行文件, `--with-openssl-rpath`指定安装路径, 必带, 如不想指定路径可以选auto

### 无法发现pip安装源的场合

```shell
$sudo apt-get install python3-pip
Reading package lists... Done
Building dependency tree Reading state information... Done
E: Unable to locate package python3-pip

$vi /etc/apt/sources.list

Then add universe category at the end of each line:

deb http://archive.ubuntu.com/ubuntu bionic main universe
deb http://archive.ubuntu.com/ubuntu bionic-security main universe
deb http://archive.ubuntu.com/ubuntu bionic-updates main universe

$sudo apt-get update
$sudo apt-get install -y python3-pip
```

alpine有时候找不到源, 多切几个试下

```shell
echo http://mirrors.aliyun.com/alpine/v3.16/main/ > /etc/apk/repositories
echo http://mirrors.aliyun.com/alpine/v3.16/community/ >> /etc/apt/sources.list

apk update
apk search py3-pip
apk add py3-pip
```

### alpine安装错误

单独安装pip有时候会报错 

```shell
# 更换源
sed -i s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g /etc/apk/repositories

# 安装python3 
apk add --update --no-cache curl jq py3-configobj py3-setuptools python3 python3-dev

# pip即时编译依赖
apk add --no-cache gcc g++ libffi-dev make zlib-dev libcec-dev libtool 

# pip3 安装
apk add wget
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

# 设置国内pip源
vim  ~/.pip/pip.conf
[global]
index-url = http://mirrors.aliyun.com/pypi/simple
[install]
trusted-host=mirrors.aliyun.com

# 使用pip/pip3下载依赖包
pip3 freeze > requirements.txt
pip3 install -r requirements.txt
```

### tensorflow配置

```shell
conda create -n tensorflow python
Proceed ([y]/n)? y

conda info --envs
source activate tensorflow

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --set show_channel_urls yes

pip install --default-timeout=100000 tensorflow

pip install numpy matplotlib scipy keras tensorboard

conda search  --full --name python
```
