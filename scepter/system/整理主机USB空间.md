
# memo

当操作系统识别USB存在问题时，建议将其重新格式化，Windows下使用diskpart。

```shell
cmd
  diskpart
    list disk
    select disk X # X是上一步展示的磁盘编号
    clean

    create partition primary
    active
    format fs=fat32 quick
  exit
exit
```

如此可还原USB空间。
