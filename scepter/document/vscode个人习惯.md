
# VSCODE个人习惯

## Ruby模式缩进

`文件->首选项->设置`的`用户设置`里添加

Tab Size改为2

一般修改了tab size还不一定生效，有这么几个设置要搜索改掉：

```conf
"editor.detectIndentation": false,
"editor.renderControlCharacters": true,
"editor.renderWhitespace": "all",
```

## 编辑器和终端的快捷切换

按`F1`，输入`>open keyboard shortcuts`，在弹出的配置界面中选择：

* `View: Focus First Editor Group`第一个编辑器组，默认快捷键`Ctrl+1`

* `Terminal: Focus Terminal`   终端，无默认快捷键

个人建议修改Ctrl+F1表示编辑器窗口，Ctrl+1表示终端窗口，物理位置对应键位比较一致，而一般情况不会用到Ctrl+2

## GBK等其他本地编码显示

“文件->首选项->设置”，修改files.autoGuessEncoding为true

在打开文件时，会尝试匹配其默认的编码方式

## 远程连接设置文件夹监控

使用remoteSSH连接远端主机时，遇到大文件夹无法监控改动的情况，参照[FAQ](https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc)修改

> "Visual Studio Code is unable to watch for file changes in this large workspace" (error ENOSPC)
> “Visual Studio Code 无法观察这个大工作区中的文件更改”（错误 ENOSPC）

```shell
cat /proc/sys/fs/inotify/max_user_watches

sudo echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf

sysctl -p
```
