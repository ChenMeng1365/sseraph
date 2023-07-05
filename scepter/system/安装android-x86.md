
# Android X86

[image-url](https://www.android-x86.org/download)

新建虚拟机，选好镜像

`设置` > `显示` > `屏幕`选择`启用3D加速`

进入安装界面选择`Advanced options...`，进入后选择`Auto_Installation`点yes（或自选），安装完成后`reboot`，重回安装界面后强制关机、退碟

重新启动，进入开机界面选择`Android-x86 8.X-...`按`E`键，将`kernal`开头的启动命令中`quiet`换成`nomodeset xforcevesa`，回车后按`B`键即可进入图形界面

其他以后慢慢掰 |=To Be Continued=>
