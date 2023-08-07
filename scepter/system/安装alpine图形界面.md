
# Alpine GUI

alpine关于GUI的安装指导放在了[WIKI](http://wiki.alpinelinux.org/wiki/Tutorials_and_Howtos)里，参考这个[DesktopEnvironments](https://wiki.alpinelinux.org/wiki/Desktop_environments_and_Window_managers)文档。

桌面包括Xfce、LXQt、KDE Plasma、Gnome、MATE，像我们这样低配的机器就先装Xfce好了。

照着文档一一做下来基本就没问题了，做如下要点笔记。

先决条件：

- alpine系统（废话）
- 创建一个账号（非必须但推荐）
- 启用`/etc/apk/repository`的community源
- 安装xorg（单独说）

## 安装xorg

这个单独执行

```shell
setup-xorg-base
```

安装显示卡兼容包，大部分X86显示卡都能兼容

```shell
apk add pciutils
lspci
apk search xf86-video
apk add xf86-video-intel
```

安装键鼠

```shell
apk search xf86-input
apk add  xf86-input-libinput # or apk add xf86-input-evdev # 至少要安装这两个

apk add xf86-input-mouse xf86-input-keyboard
apk add xf86-video-vmware xf86-input-vmmouse # 非虚拟机不装
apk add kbd # 如果numlock不工作，安装这个修复

apk add xf86-input-synaptics # 触摸板
```

xorg配置（可选）

一般xorg会自动探测设备，不需要做配置，但也可以执行`Xorg -configure`来手工配置。  
配置生成在`/root/xorg.conf.new`文件中可手动修改，配置测试确认后移动到`/etc/X11/xorg.conf`生效。

键盘布局设置（可选）

```shell
apk add setxkbmap
setxkbmap <%a language layout from /usr/share/X11/xkb/rules/xorg.lst%>
```

在`/etc/X11/xorg.conf`中写入如下配置：

```shell
Section "InputClass"
	Identifier	    "Keyboard Default"
	MatchIsKeyboard	"yes"
	Option		    "XkbLayout" "<%a language layout from /usr/share/X11/xkb/rules/xorg.lst%>"
EndSection
``` 

另一种修改方法是修改`~/.xinitrc`，比如增加英式键盘布局用`setxkbmap gb &`。

## 安装Xfce

```shell
apk add xfce4 xfce4-terminal xfce4-screensaver dbus
rc-service dbus start
rc-update add dbus
setup-devd udev

apk add lightdm lightdm-gtk-greeter
rc-service lightdm start
rc-update add lightdm

apk add elogind polkit-elogind # 允许shutdown和reboot
lbu commit
reboot

apk add gvfs udisks2 # 添加USB驱动
# 其他一些选项: apk info -d gvfs-*
# ntfs-3g        Stable, full-featured, read-write NTFS (driver)
# gvfs-cdda      CDDA support for gvfs
# gvfs-afp       AFP support for gvfs
# gvfs-goa       GNOME Online Accounts support for gvfs
# gvfs-mtp       MTP support for gvfs
# gvfs-smb       Windows fileshare support for gvfs
# gvfs-lang      Languages for package gvfs
# gvfs-afc       Apple mobile devices support for gvfs
# gvfs-nfs       NFS support for gvfs
# gvfs-dev       Backends for the gio framework in GLib (development files)
# gvfs-archive   Archiving support for gvfs
# gvfs-dav       WebDAV support for gvfs
# gvfs-fuse      FUSE support for gvfs
# gvfs-gphoto2   gphoto2 support for gvfs
# gvfs-avahi     DNS-SD support for gvfs

# 添加一些网络浏览
apk add gvfs-smb
apk add gvfs-fuse
apk add fuse-openrc
rc-service fuse start
rc-update add fuse
```

关于提权，需要安装elogind、polkit-elogind、xfce-polkit和lightdm，且要保证elogind/lightdm在Xfce桌面之前启动。

```shell
doas rc-update add elogind
doas rc-service elogind start
```

其他设置和问题参看[原文](https://wiki.alpinelinux.org/wiki/Xfce)

## 其他

```shell
$ apk add xfce4-notifyd
$ apk add lxdm
$ rc-update add lxdm

$ vi /etc/lxdm/lxdm.conf

 [base]
 ## uncomment and set autologin username to enable autologin
 autologin=root                                                                                                  
 
 ## uncomment and set timeout to enable timeout autologin,
 ## the value should >=5
 # timeout=10                                                                                                    
 
 ## default session or desktop used when no systemwide config
 # session=/usr/bin/startlxde

 ## uncomment and set to set numlock on your keyboard
 # numlock=0                                                                                                     
 
 ## set this if you don't want to put xauth file at ~/.Xauthority
 # xauth_path=/tmp                                                                                               
 
 # not ask password for users who have empty password
 # skip_password=1

vi /etc/lxdm/PostLogin

#!/bin/sh
#
# Note: this is a sample and will not be run as is.
 
rc-service xrdp restart
rc-service xrdp-sesman restart
rc-service vino restart
```
