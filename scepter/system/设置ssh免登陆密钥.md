
# ssh login

在访问终端上

```shell
cd ~/.ssh
ssh-keygen -t rsa -b 4096
```

在远程终端上

```shell
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp id_rsa.pub ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
sudo systemctl restart sshd
```

实际上，当出现多台主机访问一台机器时，那么复制pubkey成`authorized_keys`可能不行，需要把各自的pubkey粘贴到`authorized_keys`后面，改为`id_rsa.pub >> ~/.ssh/authorized_keys`