
# Powershell

TIPS:

- 微软的shell是不区分大小写的
- PS脚本文件后缀`.ps1`

```powershell
# 查看版本
Get-Host
$PSVersionTable.PSVERSION

# 查看并设置执行策略（一般脚本无法执行大都是因为执行策略设置的原因）
Get-ExecutionPolicy
Set-ExecutionPolicy [Restricted(默认)|RemoteSigned(本地可执行,网上无签不执行)|AllSigned(受信签名可执行)|Unrestricted(允许全部执行)]
```

一般的powershell命令都是`动词+名词`的形式，比如`Add New Remove Clear Get Set`等

启动powershell时可以附加一些参数: `powershell -OPTION VALUE -File SCRIPT-PATH`

- `-ExecutionPolicy Bypass` 绕行
- `-WindowStyle Hidden` 隐藏窗口
- `-NonInteractive` 非交互模式
- `-NoProfile` 不加载用户配置文件
- `-NoExit` 执行后不退出shell
- `-NoLogo` 不显示Logo

对于特殊字符较多时，可以使用base64编码载荷传入执行

```powershell
powershell -enc [BASE64编码……]
```

win32和win64两种powershell独立运行

```powershell
# win32
powershell.exe

# win64
%WinDir%\sysWoW64\windowspowershell\v1.0\powershell.exe
```
