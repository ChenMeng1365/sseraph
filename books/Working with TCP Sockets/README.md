
# Working with TCP Sockets

Berkeley套接字  
TCP/IP详解  
netcat

## Basic

### 建立套接字

建立套接字

```ruby
require 'socket'
socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM) # => Socket.new(:INET, :STREAM)
# AF_INET: IPv4 Socket, 
# AF_INET6: IPv6 Socket, 
# SOCK_STREAM: TCP, 
# SOCK_DGRAM: UDP
```

地址分配

[apnic](https://www.apnic.net/)
[iana](https://www.iana.org/)

文档查询

```shell
man CHAPTER socket
# CHAPTER:
# 1: shell命令, 2: 系统调用, 3: C函数库, 4: 特殊文件, 5: 文件格式, 7: 话题综述

ri Socket.new
```

### 建立连接

服务端: 监听的套接字, listener  
客户端: 发起连接的套接字, initiator

### 服务端生命周期

1. 创建套接字
2. 绑定
3. 监听
4. 接受消息
5. 关闭连接

```ruby
require 'socket'

```

### 客户端生命周期

### 交换数据

### 套接字读操作

### 套接字写操作

### 缓冲

### 客户端/服务器

## Advance

### 套接字选项
### 非阻塞式IO
### 连接复用
### Nagle算法
### 消息划分
### 超时
### DNS查询
### SSL套接字
### 紧急数据

## Practice

### 网络架构模式
### 串行化
### 单连接进程
### 单连接线程
### Preforking
### 线程池
### 事件驱动
### 混合模式
### 总结
