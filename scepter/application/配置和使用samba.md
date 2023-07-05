
# samba

## 安装

```shell
# 查询是否安装samba
rpm -qa | grep samba

# 安装samba
yum install -y samba
# or
mount -o remount,rw /dev/cdrom /mnt
rpm samba-X.X.X.i386.rpm
rpm samba-client-X.X.X.i386.rpm
rpm samba-commons-X.X.X.i386.rpm

# 查看并修改配置文件/etc/samba/smb.conf

# 重启samba服务
/etc/init.d/smbd restart
```

```shell
# 编辑配置
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
cat <<EOF >> /etc/samba/smb.conf
[global]
        workgroup = SAMBA
        security = user
        passdb backend = tdbsam
        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw
[temp]
        comment = share folder
        path = /share
        public = no
        writable = yes
        create mask = 0755
        directory mask = 0755
        valid users = @sam
        write list = @sam
EOF

# 添加本地账号到samba账号
useradd -g groupname username
pdbedit -a username
pdbedit -L

# 创建共享文件夹
mkdir /share
chown -R username:groupname /share
chmod -R 775 /share

# 安装命令行
apt install smbclient

# 使用命令行上传下载文件
smbclient -U username //x.x.x.x/temp
> get file
> put file
> mget file*
> mput file*

# 安装cifs
apt install cifs-utils

# 挂载用户共享目录到本地
//x.x.x.x/temp/REMOTE_DIR /home/LOCAL_USER/REMOTE_USER cifs defaults,username=REMOTE_USER,password=REMOTE_PASS,uid=UID,gid=GID
```

## 其他问题

```shell
# 用户组
groupadd groupname
groupdel groupname
gpasswd -a username groupname # 加入用户
gpasswd -d username groupname # 踢出用户

useradd -d homepath -g groupname username
usermod -G groupname,... -a username # -a为添加, 不带-a为覆盖原来的组
groups username
userdel -r username

chown -R username:groupname dirpath
chmod -R 777 dirpath
```

## 局域网内使用SAMBA提供共享目录

```shell
sudo apt install samba

sudo cat <<EOF >> /etc/samba/smb.conf
[nas]
# 共享文件夹说明
comment = nas
# 共享文件夹目录
path = /home/ubuntu/nas/
# 可被其他人看到资源名称（非内容）
browseable = yes
# 可写
writable = yes
# 新建文件的权限为 777
create mask = 0777
# 新建目录的权限为 775
directory mask = 0777
# guest访问，无需密码
public = no
EOF

sudo smbpasswd -a ubuntu
# 设置密码(自定义): samba
sudo systemctl restart smbd

sudo mkdir -p /home/ubuntu/nas
sudo mount -o uid=ubuntu,gid=ubuntu /dev/sda1 /home/ubuntu/nas

sudo lsblk -o UUID,NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL,MODEL
# 查询/dev/sda1的UUID

sudo cat <<EOF >> /etc/fstab
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /home/ubuntu/nas/ ntfs defaults,auto,users,rw,nofail 0 0
EOF

sudo reboot
```

Windows系统"我的电脑"中, 右击空白弹框选"添加一个网络位置", 输入地址:`\\192.168.168.192\nas`, 输入用户名和密码(`ubuntu/samba`之前设的)即可进入.  
Android系统下安装**SambaDroid**, 需要获取root权限才可连接.
