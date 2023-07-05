# SSH通过RSA密钥通信

私钥加密->公钥解密

公钥加密->私钥解密

1.密钥生成
```ssh-keygen -t rsa```

2.密钥配置
本地git工具和远端git仓库通信，远端git使用公钥

复制公钥```~/.ssh/id_rsa.pub```到```https://github.com/settings/keys```

3.密钥修复
如果遗失公钥，可以用私钥生成
```ssh-keygen -y -f private_key > public_key```

如果遗失私钥，无法恢复，只能重新生成
