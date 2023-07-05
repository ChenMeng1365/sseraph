
# chef

## 系统构成

chef框架包括三类角色：

- chef-server：服务节点，通过REST API管理所有节点，和数据库、消息队列通信，并提供一个WebUI
- chef-workstation：工作站节点，用于编辑和管理节点，大部分管理工作都在这个节点进行
- chef-client：用户节点，接受工作站的管理配置(cookbook/recipe)并执行

## 事前准备

安装包建议直接从[官网](https://downloads.chef.io/)下载

全部节点均需要64位系统，chef-server至少需要4G内存，chef-workstation至少需要2G内存
也可以多种角色安装到一台机器上，配置需相应的拔高

```shell
# 关闭iptables
chkconfig iptables off  
# 关闭ipv6防火墙
chkconfig ip6tables off

#关闭firewall
systemctl stop firewalld.service
systemctl disable firewalld.service

# 关闭SELinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# 不同步会导致，登录认证无法通过
ntpdate -u TIMESERVER

# Server、Workstation、Nodes均要设置hostname、配置hosts

# 设置Chef Server
hostnamectl set-hostname chefserver
# 设置Workstation
hostnamectl set-hostname chefworkstation
# 设置Node
hostnamectl set-hostname chefnode

# 配置hosts
vim /etc/hosts
192.168.0.31  chefserver
192.168.0.39  chefworkstation
192.168.0.40  chefnode
```

## 安装chef-server

系统配置修改

```shell
#内核参数调整
vi /etc/sysctl.conf
# 物理内存使用90%再使用swap
vm.swappiness = 10
# 1 表示开启重用，允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭
net.ipv4.tcp_tw_reuse = 1
# 1 表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭
net.ipv4.tcp_tw_recycle = 1
# 定义了系统中每一个端口最大的监听队列的长度, 对于一个经常处理新连接的高负载web服务环境，默认128太低
net.core.somaxconn = 2048
# 表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间
net.ipv4.tcp_fin_timeout = 30
# 该参数决定了, 每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目，不要设置过大
net.core.netdev_max_backlog = 8096
# 控制分配内存行为，不允许overcommit(内存分配不要乱设)
vm.overcommit_memory= 2
# 由于系统物理内存和swap内存都为4G(内存分配不要乱设)
vm.overcommit_radio=0
# (semmsl  semmns  semopm  semmni)
# semmsl：每个信号量set中信号量最大个数；
# semmns：linux系统中信号量最大个数；
# semopm：semop系统调用允许的信号量最大个数设置，
# 设置成和semmsl一样即可；
# semmni：linux系统信号量set最大个数；
kernel.sem = 500 512000 500 1024

# 重启使其生效
sysctl -p

# 关闭允许hugepage可以动态分配
echo never> /sys/kernel/mm/transparent_hugepage/enabled

# 资源参数调整
# 查看资源参数命令：ulimit -a
# 打开文件句柄数调整为65535
ulimit -n 65535
# 最大用户进程数调整为 65535
ulimit -u 65535
```

安装过程

```shell
rpm -ivh chef-server-core-12.17.33-1.el7.x86_64.rpm
chef-server-ctl reconfigure
# 注意：
# 1.有些协议需要选同意才能继续执行，确认有时限，等太久配置程序会退出
# 2.打开80、443、9200端口以保证服务可访问
chef-server-ctl install chef-manage --path /chef/software/chef-manage-2.5.16-1.el7.x86_64.rpm # 也可以不指路径，会自动从官网上下载
chef-server-ctl reconfigure
chef-manage-ctl reconfigure
# 注意：
# 1.有些协议需要选同意才能继续执行，确认有时限，等太久配置程序会退出
# 2.浏览协议时出现冒号(":")按下q键并输入yes继续执行，不要按太多太快以免干扰影响后续配置

# 进入web界面的第一个用户只能通过命令行分配，组织机构可以进去后再分配
# 路径是绝对路径，用于外部存储，不指也会分配
chef-server-ctl user-create USER_NAME FIRST_NAME LAST_NAME EMAIL 'PASSWORD' --filename FILE_NAME
chef-server-ctl org-create ORG_NAME ORG_FULL_NAME -f FILE_NAME
```

然后可以登陆`https://chefserver`操作

## 安装和配置chef-workstation

```shell
rpm -ivh chef-workstation-0.1.137-1.el6.x86_64.rpm
chef -v

# 配置ruby路径
# 对于不使用ruby环境的只需执行
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
# 使用了其他ruby环境的，要为root配置chef-workstation自带的ruby路径，保持系统路径顺序如下：(如果弄反了embeded/bin和bin会有提示)
vi /root/.bash_profile
export PATH="/opt/chef-workstation/embedded/bin:$PATH"
export PATH="/opt/chef-workstation/bin:$PATH"
eval "$(chef shell-init bash)"
# 检测ruby路径
which ruby #=> /opt/chef-workstation/embedded/bin/ruby
# 注意：如果从普通账号切到root的，要先source .bash_profile
```

安装完成后登陆到`https://chefserver`
登陆指定用户后选择`Administration`页面，选择相应的组织`Organization`，下载`Starter Kit`生成的zip文件包
上传到workstation节点

建立一个目录，比如`/opt/chef-data`，将`chef-starter.zip`解压到该路径下

```shell
cd /opt/chef-data
unzip chef-starter.zip
cd chef-repo/
cd .chef
```

※建议将.chef写于.gitignore

注意.chef下应包含`USERNAME.pem`、`ORG-validator.pem`和`config.rb`，config.rb以前版本可能叫knife.rb，基本就是一个配置文件，检查其中项目如下：

```shell
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "USERNAME"
validation_client_name   'ORG-validator'
validation_key           "#{current_dir}/ORG-validator.pem"
client_key               "#{current_dir}/USERNAME.pem"
chef_server_url          "https://node109/organizations/ORG"
cookbook_path            ["#{current_dir}/../cookbooks"]
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
```

缺少的文件从chef-server拷过来，缺少的配置项可以参照上面补全，`USERNAME`和`ORG`就是chef-server上指定的用户名和组织名

配置完项目后就可以验证安装效果了

```shell
# 获取chef-server的证书并验证
knife ssl fetch
knife ssl check

# 查询工作节点列表
knife node list # 最初为空，添加node后才会有
```

## 安装chef-client

```shell
rpm -ivh chef-14.2.0-1.el7.x86_64.rpm
chef-client -v
```

有ruby环境的还可以`gem install chef`安装

## 添加用户节点到工作站节点

在chef-workstation上执行如下命令可添加节点

```shell
knife bootstrap x.x.x.x --ssh-user USERNAME --ssh-password PASSWORD --node-name NODE_DOMAIN
```

>注意：
>
>- 节点地址必须是点分式IP地址，写域名会连接失败
>- 节点名称注册的是什么就是什么，和`/etc/hosts`里设的域名要一致，转译或简写的域名都不行
