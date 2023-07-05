# 命令

```shell
vmstat [seconds] [counters]
vmstat --timestamp [seconds] [counters] > [filename] &
```

## 统计参数

r ：    运行队列数，如果运行队列过大，表示你的CPU很忙，会造成CPU使用率很高

b ：    阻塞的进程数
swpd ：虚拟内存已使用的大小，如果大于0，表示你的机器物理内存不足了，如果不是程序内存泄露的原因，那么你该升级内存了或者把耗内存的任务迁移到其他机器

free ： 空闲的物理内存的大小

buff ： 系统占用的缓存大小

cache ：直接用来记忆我们打开的文件,给文件做缓冲

si ：   每秒从磁盘读入虚拟内存的大小，如果这个值大于0，表示物理内存不够用或者内存泄露了

us ：   用户CPU时间

sy ：   系统CPU时间

so ：   每秒虚拟内存写入磁盘的大小，如果这个值大于0，同上

sy ：   系统CPU时间，如果太高，表示系统调用时间长，例如IO操作频繁

id ：   空闲 CPU时间，一般来说，id + us + sy = 100

wt ：   等待IO CPU时间

## 命令参数

-a, --active           active/inactive memory

-f, --forks            number of forks since boot

-m, --slabs            slabinfo

-n, --one-header       do not redisplay header

-s, --stats            event counter statistics

-d, --disk             disk statistics

-D, --disk-sum         summarize disk statistics

-p, --partition \<dev\>  partition specific statistics

-S, --unit \<char\>      define display unit

-w, --wide             wide output

-t, --timestamp        show timestamp
