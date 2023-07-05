
# 调整chrome安全选项

有时候chrome的安全选项会禁止你访问本地资源，这个时候可以制作特殊的启动项快捷方式来打开浏览器

```shell
# 允许跨站调试js
$browser/chrome.exe --args --disable-web-security --user-data-dir

# 允许访问本地文件
$browser/chrome.exe --allow-file-access-from-files
```

建议保留常规打开方式，毕竟存在风险
