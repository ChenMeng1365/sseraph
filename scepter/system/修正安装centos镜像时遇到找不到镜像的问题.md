
# centos安装时找不到镜像问题

使用U盘安装系统镜像经常会出现找不到镜像的问题，主要提示`dracut-initqueue: Warning: dracut-initqueue timeout - starting timeout scripts`
遇到这种情况主要是刻录时镜像盘标签命名超过了长度，光盘不会出现这种情况但U盘会

## 解决办法

1. 修改镜像盘标签`/isolinux/isolinux.cfg`
2. 修改启动菜单命令（在安装选项处按tab）

目标是一样的，需要修改`inst.stage2=hd:`后面的内容，默认会是标签名，也可以直接修改为U盘盘符，稳定启动

## 寻找U盘的盘符的方法

如果实在不知道是哪个盘符，可以默认安装，当出现提示`dracut-initqueue: Warning: dracut-initqueue timeout - starting timeout scripts`后，耐心等待超时检查记录完，会弹出命令行提示符

这个时候输入

```shell
cd /dev
ls |grep sd
```

盘符名称样式是`/dev/sda`，`/dev/sdb`和`/dev/sdc`这些的，一般字母后面还跟一个1-4的数字，硬盘U盘都一样，分不清可以当场拔掉U盘看看哪个名称消失了（不推荐），记下盘符(比如是`/dev/sdb4`)

重启后重新修改启动命令

```shell
initrd=initrd.img inst.stage2=hd:/dev/sdb4 quiet
```

一般就能进入安装界面
