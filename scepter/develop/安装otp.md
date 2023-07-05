
# OTP

```shell
git clone https://github.com/erlang/otp.git
cd otp
git checkout maint-24    # current latest stable version
./configure
make
make install
```

一般需要`curses`, 常规不行,需要开发版`apt install libncurses5-dev`

```shell
wget https://github.com/elixir-lang/elixir/releases/download/v1.13.4/Precompiled.zip
unzip Precompiled.zip
export PATH="$PATH:/path/to/elixir/bin"
```
