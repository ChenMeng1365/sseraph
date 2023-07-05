
### [Dockerfile]
```
FROM       ruby
MAINTAINER matthrew
RUN        sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN        apt update
RUN        apt install -y vim
RUN        gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN        bundle config mirror.https://rubygems.org https://gems.ruby-china.com
CMD        ["irb"]
```

### [How To Use]
```
sudo docker run -itd --name ruby-lab -v ~/workspace:/workspace -p 8080:8080 ruby-lab /bin/bash
sudo docekr exec ruby-lab /bin/bash
```