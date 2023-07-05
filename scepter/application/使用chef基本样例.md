
# chef

## 文档

[chef](https://docs.chef.io/)

## 基本样例

假设安装集群角色如下：

* chefserver
* chefworkstation
* chefnode

在chefworkstation上执行如下操作：

1.创建一个cookbook，这里名叫`first_cookbook`

```shell
cd /opt/chef-data/chef-repo/cookbooks
chef generate cookbook first_cookbook

vim first_cookbook/recipes/default.rb
# 编写recipe
execute 'repo_ifconfig' do
  command 'ifconfig >> /root/ifconfig.txt'
  ignore_failure true
end
```

2.上传cookbook到chefserver

```shell
cd /opt/chef-data/chef-repo/cookbooks
knife cookbook upload first_cookbook

# 查看cookbook列表
knife cookbook list
```

3.将cookbook分发到指定节点上

```shell
cd /opt/chef-data/chef-repo/cookbooks
knife node run_list add chefnode first_cookbook
```

4.指定chefnode运行cookbook和recipe

```shell
cd /opt/chef-data/chef-repo/cookbooks
knife ssh chefnode 'sudo chef-client' -m -x USER -P PASSWORD
```

也可以在chefnode上执行配置：

```shell
chef-client
```

就会根据cookbook的配置来运行。本样例(first_cookbook)如下操作查看执行结果：

```shell
ls /root
cat /root/ifconfig.txt
```

## 备注

* chef是项目维护命令，knife是主要的通信命令
* recipe就是直接拿rb文件堆
* 可以`chef-apply filename`直接应用recipe文件，用于调试
