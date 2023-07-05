#

## rbenv篇

由于RVM被墙，经常出现下载失败的情况，可以使用rbenv作为替代，原理和rvm类似，都是修改PATH单独管理发行版

安装方法参照[ruby-china](https://ruby-china.org/wiki/rbenv-guide)，前提安装git

```shell
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone git://github.com/jamis/rbenv-gemset.git  ~/.rbenv/plugins/rbenv-gemset # 可选
git clone git://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update # 推荐
git clone git://github.com/AndorChen/rbenv-china-mirror.git ~/.rbenv/plugins/rbenv-china-mirror # 推荐
```

然后改写`.bash_profile`

```shell
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

刷新shell或source即可使用rbenv

安装ruby前先安装编译依赖库，可查询[安装指南](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment)

```shell
# redhat/centos
yum install -y gcc gcc-c++ bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
# debian/ubuntu
apt-get install -y gcc g++ make libssl-dev libyaml-dev zlib1g-dev
# alpine（啥都没有，每个都单独装，dev版也可以装一个）
apk add gcc g++ make cmake bzip2 openssl libffi readline zlib gdbm ncurses perl bash
```

安装和设置版本

```shell
rbenv install --list         # 列出所有 ruby 版本
rbenv install 1.9.3-p392     # 安装指定版本
rbenv versions               # 列出安装的版本
rbenv version                # 列出正在使用的版本
rbenv global 1.9.3-p392      # 默认使用 1.9.3-p392
rbenv shell 1.9.3-p392       # 当前的 shell 使用 1.9.3-p392, 会设置一个 `RBENV_VERSION` 环境变量
rbenv local jruby-1.7.3      # 当前目录使用 jruby-1.7.3, 会生成一个 `.rbenv-version` 文件
```

安装完成后记得更换gem源

```shell
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
bundle config mirror.https://rubygems.org https://gems.ruby-china.com
```

## rvm篇（既）

要是能用[rvm](https://ruby-china.org/wiki/rvm-guide)还是可以尝试的

```shell
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable

source ~/.bashrc
source ~/.bash_profile
echo "ruby_url=https://cache.ruby-china.com/pub/ruby" > ~/.rvm/user/db # 修改安装源，推荐
# or
source ~/.rvm/scripts/rvm
```

安装和设置版本

```shell
rvm list known
rvm install 2.2.0 --disable-binary
rvm use 2.2.0
rvm use 2.2.0 --default 
rvm list
rvm remove 1.8.7
```

gemset

```shell
rvm use 1.8.7
rvm gemset create rails23
rvm use 1.8.7
rvm use 1.8.7@rails23
rvm gemset list
rvm gemset empty 1.8.7@rails23
rvm gemset delete rails2-3

```

## 问题篇

* SSL证书问题

近期出现的SSL证书过期的错误，不知道是安全弄的还是网络波动，总之安装和升级gem前都会出现这个

```shell
ERROR:  SSL verification error at depth 1: unable to get local issuer certificate (20) 
ERROR:  You must add /O=Digital Signature Trust Co./CN=DST Root CA X3 to your local tr sted store
```

直接忽略证书问题，方法如下：

```shell
vi ~/.gemrc

:ssl_verify_mode: 0
```

windows下`~`为用户的文档目录，可以很容易找到.gemrc，修改即可

* 安装msys2添加源

```shell
vi /etc/pacman.d/mirrorlist.mingw32

Server = http://mirrors.ustc.edu.cn/msys2/mingw/i686


vi /etc/pacman.d/mirrorlist.mingw64

Server = http://mirrors.ustc.edu.cn/msys2/mingw/x86_64
Server = http://mirrors.ustc.edu.cn/msys2/msys/$arch

msys2
pacman -Syuu

# 反复重启pacman -Syuu
pacman -S mingw-w64-x86_64-cmake mingw-w64-x86_64-extra-cmake-modules
pacman -S mingw-w64-x86_64-make
pacman -S mingw-w64-x86_64-gdb
pacman -S mingw-w64-x86_64-toolchain
pacman -S mingw-w64-x86_64-gcc
pacman -S make
pacman -S cmake
```

* BUILD FAILED

```shell
$rbenv install 3.0.1
Downloading ruby-3.0.1.tar.gz...
-> https://cache.ruby-china.com/pub/ruby/3.0/ruby-3.0.1.tar.gz
error: failed to download ruby-3.0.1.tar.gz

BUILD FAILED (CentOS Linux 7 using ruby-build 20210611-1-g1b477ae)
```

某次安装中遇到非常诡异的BUILD FAILED失败问题，编译什么版本都失败，而且不提示任何原因，参考[ruby-build issues](https://github.com/rbenv/ruby-build/issues)试了什么重装ruby-build、`rbenv rehash`都无果

排查方法：检查`/tmp`

```shell
$cd /tmp && ls
ruby-build.19700101000133.1074.log  ruby-build.19700101000424.1321.log   ruby-build.19700114072029.24748.log  ruby-build.19700114073118.25354.log
ruby-build.19700101000339.1173.log  ruby-build.19700114065432.24457.log  ruby-build.19700114072106.24825.log  ruby-build.19700114073124.25428.log
ruby-build.19700101000408.1247.log  ruby-build.19700114065447.24531.log  ruby-build.19700114072200.24946.log  systemd-private-e5945d4c7fa64fa8b86a6da6546fc01d-chronyd.service-ykc16m
```

这一看发现问题了，所有时间都是19700101，看来是因为时间没有同步

```shell
$ntpdate 0.asia.pool.ntp.org
 1 Jan 08:22:32 ntpdate[1751]: sendto(202.28.116.236): Operation not permitted
 1 Jan 08:22:32 ntpdate[1751]: sendto(ns.tu.ac.th): Operation not permitted
 1 Jan 08:22:32 ntpdate[1751]: sendto(ntp-b2.nict.go.jp): Operation not permitted
 1 Jan 08:22:32 ntpdate[1751]: sendto(time.cloudflare.com): Operation not permitted
 1 Jan 08:22:34 ntpdate[1751]: sendto(202.28.116.236): Operation not permitted
 1 Jan 08:22:34 ntpdate[1751]: sendto(ns.tu.ac.th): Operation not permitted
 1 Jan 08:22:34 ntpdate[1751]: sendto(ntp-b2.nict.go.jp): Operation not permitted
 1 Jan 08:22:34 ntpdate[1751]: sendto(time.cloudflare.com): Operation not permitted
 1 Jan 08:22:36 ntpdate[1751]: sendto(202.28.116.236): Operation not permitted
 1 Jan 08:22:36 ntpdate[1751]: sendto(ns.tu.ac.th): Operation not permitted
 1 Jan 08:22:36 ntpdate[1751]: sendto(ntp-b2.nict.go.jp): Operation not permitted
 1 Jan 08:22:37 ntpdate[1751]: sendto(time.cloudflare.com): Operation not permitted
```

强制同步发现还不能成功，猛然记起iptables开到最高了，赶紧加了两条

```shell
$sudo iptables -I INPUT -p udp -m udp --dport 123 -j ACCEPT
$sudo iptables -I OUTPUT -p udp -m udp --sport 123 -j ACCEPT
$sudo iptables -nL --line
Chain INPUT (policy DROP)
num  target     prot opt source               destination         
1    ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0            udp dpt:123
2    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED
5    ACCEPT     tcp  --  x.x.x.x/x            0.0.0.0/0            state NEW tcp dpt:12345
12   REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-net-unreachable

Chain FORWARD (policy DROP)
num  target     prot opt source               destination         
1    REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited

Chain OUTPUT (policy DROP)
num  target     prot opt source               destination         
1    ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0            udp spt:123
2    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED
4    ACCEPT     tcp  --  0.0.0.0/0            x.x.x.x/x            state NEW tcp spt:12345
12   REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited

$ntpdate 0.asia.pool.ntp.org
 7 Jul 17:01:16 ntpdate[1776]: step time server 133.243.238.163 offset 1625647097.395866 sec
```

然后就正常了
