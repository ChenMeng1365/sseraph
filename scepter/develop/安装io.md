
# Io

## linux

源码安装，需要用到cmake，过程参照其git说明

```shell
git clone --recursive https://github.com/IoLanguage/io.git

cd io
mkdir build
cd build
cmake .. # 一些选项：-DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/usr/local/bin -DWITHOUT_EERIE=1
make
sudo make install
```

安装后可以将eerie导入shell环境

```shell
vi ~/.bash_profile

EERIEDIR=/root/.eerie
PATH=$PATH:$EERIEDIR/base/bin:$EERIEDIR/activeEnv/bin
export EERIEDIR PATH

source ~/.bash_profile
```

注意eerie是给root用户使用的，给一般用户授权并不合适

```shell
sudo chown -R <用户名>:<用户名> .eerie/
```

## windows

还是老样子，没更新
