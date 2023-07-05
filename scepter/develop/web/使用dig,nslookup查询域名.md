
# installment

```shell
yum install -y bind-utils
```

# nslookup

```shell
nslookup [-option] [name | -] [server]
```

参数说明:

- option：通过set命令设置选项
- name：查询的域名
- server：指定DNS的主机IP

set命令说明:

- set all: 打印当前的选项
- set calss=value: 查询的类型，一般为Internet
- set debug: 调试模式
- set d2: 详细调试模式
- set domin=name: 设置默认域名
- set search: ...
- set port=value: 设置DNS端口
- set querytype=value: 改变查询的信息的类型，默认为A纪录
- set type=value: 和set querytype一样
- set recurse: 设置查询类型为递归(默认)；若set norecurse，查询类型为迭代
- set retry=number: 设置重试的次数
- set timeout=number: 设置等待应答的限制时间(单位秒)，超出即为超时，如果还设置了重试，会将超时值加倍重新查询
- set vc: 通过tcp方式查询
- set fail: ...

# dig

```shell
dig [@global-server] [domain] [q-type] [q-class] {q-opt} {d-opt}
```

参数说明:

- @global-server: 默认以/etc/resolv.conf作为DNS查询的主机，可以填入其它DNS主机IP
- domain: 要查询的域名
- q-type: 查询记录的类型，比如a、any、mx、ns、soa、hinfo、axfr、txt等，默认查询a
- q-class: 查询的类别，相当于nslookup中的set class。默认为in（Internet）
- q-opt: 查询选项，可以有好几种方式，比如：-f file为通过批处理文件解析多个地址；-p port指定另一个端口（缺省的DNS端口为53）
- d-opt: dig特有的选项，使用时在参数前加上一个“+”号。常用选项：+vc：使用TCP协议查询；+time=###：设置超时时间；+trace：从根域开始跟踪查询结果
