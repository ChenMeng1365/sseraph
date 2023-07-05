
# Mix

```shell
mix new PROJECT --module MODULE_NAME
cd PROJECT

# 测试:(MOD_test.exs:LINENO)
mix test

# 清理环境
mix clean

# 编译环境
mix compile

# 编译脚本并执行
mix escript.build
./MOD

# 交互式运行
iex -S mix

# 环境设置
set "MIX_ENV=XXX"
MIX_ENV=(dev|test|prod)
```

入口和工程配置设置

`MOD.ex`

```elixir
defm MOD do
  def main(args\\[])do
  end
end
```

`Mix.exs`

```elixir
def project do
  ...
  escript: [main_module: MOD],
  build_embeded: Mix.env==:prod,
  ...
end
```

# requirements

加速站点参看[Mirrors](https://hex.pm/docs/mirrors)

导入环境变量

```shell
export HEX_MIRROR="https://hexpm.upyun.com"
export HEX_CDN="https://hexpm.upyun.com"
```

临时选择镜像

```shell
HEX_MIRROR=https://repo.hex.pm mix deps.get
mix hex.config https://hexpm.upyun.com https://repo.hex.pm
```

报错执行

```shell
** (Mix) Could not verify authenticity of fetched registry file. This may happen because a proxy or some entity is interfering with the download or because you don't have a public key to verify the registry.

You may try again later or check if a new public key has been released in our public keys page: https://hex.pm/docs/public_keys

$ mix local.hex

# 对hex v0.21.0以下
$ mix archive.install github hexpm/hex ref 6d7ff1236
$ mix local.hex
```
