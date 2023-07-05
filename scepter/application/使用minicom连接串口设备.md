
# USB-Serial

minicom类似于windows上的超级终端, 是一个和串口通信的工具

```shell
apt-get install minicom
```

查询设备会发现类似`/dev/ttyUSB0`这样的设备

```shell
dmesg | grep ttyS*    # 传统串口
dmesg | grep ttyUSB*  # USB转串口
```

直接进入minicom

```shell
minicom -s              # 进入配置模式
minicom -D /dev/ttyUSB0 # 进入指定串口
```

会有一个文字版的图形界面, 根据提示按键配置  
主要配置`Serial Port Setup`部分, 也可以将选项写入配置文件`/etc/minicom/minirc.ttyUSB0`或`/etc/minirc.df1`等路径

```shell
pu port             /dev/ttyUSB0
pu baudrate         9600
pu bits             8
pu parity           N
pu stopbits         1
pu minit
pu mreset
pu rtscts           No
```

一般选择了正确的串口后就会和设备交互了  
如果串口无反应, 检查是否选错了设备

再就是USB串口是一个linux默认有但不加载的模块, 使用前需要加载一下才能使用

```shell
# 以如下顺序加载USB串口模块
modprobe usbserial
modprobe pl2303

# 加载完成后查询会发现该模块正常工作
lsmod | grep serial
```

还有一点就是要保证读写权限

```shell
sudo chmod 666 /dev/ttyUSB0
```

要捕获串口内容, 可以`-C 日志路径`选项或在配置菜单中设置来保存交互的过程
