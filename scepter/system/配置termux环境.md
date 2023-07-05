
# Termux

```shell
# 存储权限
termux-setup-storage
pwd | ls #=> /data/data/com.termux/files/home

# 问候界面
vim $PREFIX/etc/motd

# 修改默认键盘
echo "extra-keys = [['ESC', '+', '-','=', '/','\$', 'BACKSPACE','HOME','END'],['{', '}','[',']','(', ')','UP','<','>'],['TAB', 'CTRL', 'ALT', '&','\"','LEFT', 'DOWN', 'RIGHT','ENTER']]" > $HOME/.termux/termux.properties
```

```shell
# 其他一些软件
pkg install fish
chsh -s fish

pkg install vim curl wget git unzip unrar clang python nodejs
pip install pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pkg install -y python ndk-sysroot clang make libjpeg-turbo
pip install pillow
pkg install libxml2 libxslt libiconv libllvm clang libzmq  libc++ freetype libpng pkg-config
pip install lxml
pip install matplotlib
```
