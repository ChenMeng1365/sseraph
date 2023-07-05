
# Web Performance Testing

## webbench

### 安装

```shell
tar zxvf webbench-1.5.tar.gz 
cd webbench-1.5
make 
make install
```

容易出的问题是

```text
webbench.c: 在函数‘alarm_handler’中:
webbench.c:77:31: 警告：未使用的参数‘signal’ [-Wunused-parameter]
 static void alarm_handler(int signal)
                               ^
cc -Wall -ggdb -W -O  -o webbench webbench.o  
```

这个警告无视掉就好了，如果安装出现问题，检查编译工具是否齐全

```shell
yum -y install gcc automake autoconf libtool make
yum -y install ctage
```

再就是

```shell
install报错：
install: cannot create regular file `/usr/local/man/man1': No such file or directory
make: *** [install] Error 1
```

缺少目录，手工补一个，再`make install`就没问题了

```shell
mkdir -p /usr/local/man/man1
```

### 使用

`webbench -c <并发数> -t <持续时间> <页面URL>`
