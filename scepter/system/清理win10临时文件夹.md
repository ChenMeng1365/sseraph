
# $WINDOWS.~BT

这个文件夹是系统更新后存放旧版本系统的地方, 直接删很难删除, 而"存储"页面有时候也找不到清理这个功能的选项, 通过如下命令可以稳定删除

```bat
takeown /F C:\$Windows.~BT\* /R /A
icacls C:\$Windows.~BT\*.* /T /grant administrators:F
rmdir /S /Q C:\$Windows.~BT\
```
