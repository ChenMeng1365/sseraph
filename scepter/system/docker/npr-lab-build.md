
### NPR = Node Python Ruby

不要使用rvm安装ruby，非常糟心

### 方法1
1. build a ruby-based image
```
FROM       ruby
MAINTAINER matthrew
RUN        sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN        apt update
RUN        apt install -y vim
RUN        gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN        bundle config mirror.https://rubygems.org https://gems.ruby-china.com
CMD        ["irb"]
AS         ruby-lab
```
2. running
```
docker run --name npr-lab -v ~/workspace:/workspace -p 4074:4074 -p 8864:8864 ruby-lab /bin/bash
docker exec -it npr-lab /bin/bash
```

3. install python & nodejs inside
```
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2019.07-Linux-x86_64.sh
chmod +x Anaconda3-2019.07-Linux-x86_64.sh
./Anaconda3-2019.07-Linux-x86_64.sh
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt install -y nodejs
```
也可以选用常规方法下载并安装python3，随便~

### 方法2
1. build a python-based image with ruby & nodejs
```
FROM       python
MAINTAINER matthrew
RUN        sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN        apt update
RUN        curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN        apt install -y vim ruby nodejs
RUN        gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN        gem install bundle
RUN        bundle config mirror.https://rubygems.org https://gems.ruby-china.com
CMD        ["irb"]
AS         npr-lab
```
2. now can use it
```
sudo docker run -itd --name npr-lab -v ~/workspace:/workspace -p 4074:4074 -p 8864:8864 npr-lab /bin/bash
sudo docker exec -it npr-lab /bin/bash
```

### 方法3
```
FROM       alpine
MAINTAINER matthrew
RUN        sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN        apk update
RUN        apk add --no-cache nodejs
RUN        apk add --no-cache python3
RUN        apk add --no-cache erlang
RUN        apk add --no-cache elixir   # option
RUN        apk add --no-cache ruby-dev
RUN        apk add --no-cache crystal  # option
```