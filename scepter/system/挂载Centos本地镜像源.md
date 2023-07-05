
# 挂载Centos本地镜像源

Centos默认Yum源

```shell
[root@localhost ~]# ll /etc/yum.repos.d/
total 32
-rw-r--r--. 1 root root 1664 Nov 23 21:16 CentOS-Base.repo
-rw-r--r--. 1 root root 1309 Nov 23 21:16 CentOS-CR.repo
-rw-r--r--. 1 root root 649 Nov 23 21:16 CentOS-Debuginfo.repo
-rw-r--r--. 1 root root 314 Nov 23 21:16 CentOS-fasttrack.repo
-rw-r--r--. 1 root root 630 Nov 23 21:16 CentOS-Media.repo
-rw-r--r--. 1 root root 1331 Nov 23 21:16 CentOS-Sources.repo
-rw-r--r--. 1 root root 5701 Nov 23 21:16 CentOS-Vault.repo
```

备份配置文件

```shell
[root@localhost ~]# mkdir /opt/centos-yum.bak
[root@localhost ~]# mv /etc/yum.repos.d/* /opt/centos-yum.bak/
```

准备镜像文件挂载到某个目录

```shell
[root@localhost ~]# mkdir /mnt/iso
[root@localhost ~]# mv CentOS-7-x86_64-DVD-1810.iso /mnt/iso
[root@localhost ~]# mount /mnt/iso/CentOS-7-x86_64-DVD-1810.iso /opt/centos

# 如果是挂载系统镜像, 可以选择类型`-t iso9660`, 也可以默认, mount会自动匹配挂载类型, `-o loop`用来在不烧录镜像的前提下检查其内容
```

编辑repo文件指向挂载目录

```shell
[root@localhost ~]# cat <<EOF >> /etc/yum.repos.d/local.repo
[local]
name=local
baseurl=file:///opt/centos
enabled=1
gpgcheck=0
EOF
```

清除缓存

```shell
[root@localhost ~]# yum clean all
Loaded plugins: fastestmirror
Cleaning repos: local
Cleaning up list of fastest mirrors
Other repos take up 68 M of disk space (use --verbose for details)

[root@localhost ~]# yum makecache
Loaded plugins: fastestmirror
Determining fastest mirrors
local | 3.6 kB 00:00:00
(1/4): local/group_gz | 166 kB 00:00:00
(2/4): local/primary_db | 6.0 MB 00:00:00
(3/4): local/filelists_db | 7.1 MB 00:00:00
(4/4): local/other_db | 2.6 MB 00:00:00
Metadata Cache Created

[root@localhost ~]# yum repolist
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
repo id                                                  repo name
local                                                    local
repolist: 4,021
```

开机自动挂载

```shell
[root@localhost ~]# echo "/mnt/iso/CentOS-7-x86_64-DVD-1810.iso /opt/centos iso9660 loop 0 0" >> /etc/fstab
```

取消挂载

```shell
[root@localhost ~]# umount /opt/centos
```
