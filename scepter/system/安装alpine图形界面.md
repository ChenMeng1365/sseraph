
# Alpine GUI

[xDE](http://wiki.alpinelinux.org/wiki/Tutorials_and_Howtos)

```shell
$ setup-xorg-base
$ apk add xf86-input-keyboard xf86-input-mouse xf86-video-vmware xf86-input-vmmouse # 非虚拟机后面两个可以不装
$ apk add dbus
$ rc-service  dbus start
$ rc-update add dbus
$ apk add lightdm
$ rc-service lightdm start
$ rc-update add lightdm
$ apk add lightdm-gtk-greeter
$ apk add xfce4
$ reboot
$ startx # 或 startxfce4
```

others

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
