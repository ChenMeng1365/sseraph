# 　

## 客户端配置

配置用户名、邮箱后，只需要输入一次密码就可以免密操作，多个账号可以同时存储

```shell
git config --global user.name "username"
git config --global user.email "username@mail.name"
git config --global credential.helper store
```

当使用多个git仓库时，ssh-key要为不同仓库配置不同的key，这个时候就不建议默认空口令密钥

```shell
ssh-keygen -t rsa -f ~/.ssh/id_rsa_github -C "GithubAccount"
ssh-keygen -t rsa -f ~/.ssh/id_rsa_gitlab -C "GitlabAccount"
ssh-keygen -t rsa -f ~/.ssh/id_rsa_gitee -C "GiteeAccount"
ssh-keygen -t rsa -f ~/.ssh/id_rsa_gitea -C "GiteaAccount"

# 生成密钥后将每个密钥编辑对应的仓库
cd ~/.ssh
vim config

Host github.com
HostName github.com
User GithubAccount
IdentityFile ~/.ssh/id_rsa_github

Host gitlab.com
HostName gitlab.com
User GitlabAccount
IdentityFile ~/.ssh/id_rsa_gitlab

Host gitee.com
HostName gitee.com
User GiteeAccount
IdentityFile ~/.ssh/id_rsa_gitee

Host gitea.com
HostName gitea.com
User GiteaAccount
IdentityFile ~/.ssh/id_rsa_gitea
```

最后再将不同密钥上传到不同git仓库的ssh-key中关联，那么每个仓库都会自动选择对应的账号和密钥

## 常用操作

构建本地仓库

```git clone git@github.com:username/reponame.git```

当前仓库状态

```git status```

更新代码/文档

```git add *```

提交到本地仓库

```git commit -m "message"```

推送到远程仓库

```git push```

## 分支、拉取分支、选择分支

获取远程所有分支

```git fetch```

当前所有分支

```git branch -a```

切换本地仓库分支

```git checkout "branch name"```

## 版本库的工作状态

工作区:working

缓存区:stage

本地仓库:local

远程仓库:remote

查看当前状态

```bash
git status
```

## 常规流程

### init

```bash
mkdir <dirpath>
cd <dirpath>
git init
```

### working

在工作区修改，未提交到缓存区时，可以查看当前修改

```bash
git diff <filepath>
git diff HEAD -- <filepath> # 当前工作区修改和仓库最近版本的对比
```

### working --> stage

将工作区添加/修改提交到缓存区

```bash
git add <filepath>
```

在工作区删除文件，除了rm删除外，可以用git rm再提交

```bash
git rm <filepath>
```

使用git rm的好处就是会在版本库生成备份，可以用于恢复，如果直接rm就不好找回文件了

### stage --> working

如果想撤回修改，状态将回到working

```bash
git checkout -- <filepath>
```

"--"不能省略，没有它代表"切换到另一分支"

### stage --> local

将缓存区修改提交到本地仓库

```bash
git commit -m <message>
```

### local

对于已提交到本地仓库的修改，可以查看提交记录

```bash
git log # 详细信息
git log --pretty=oneline # 单行显示
```

commit id为十六进制字符串，用来唯一标识修改

commit message用来供人回忆修改的概要，所以一定要描述准确

### local --> stage

回退版本需要根据commit id来操作

```bash
git reset --hard <commit id>
```

HEAD相当于当前仓库的指针，指向最新的修改，也可以以HEAD来定义回退坐标

```bash
git reset --hard HEAD^ # HEAD^指代上一次修改，HEAD^^指代上两次修改，HEAD^100指代上100次修改
git reset HEAD <filepath> # 将提交的修改撤销掉，状态回到stage
```

git reset把较新修改回退后，原本修改无法再通过git log看到，可以通过git reflog查看完全

```bash
git reflog # 所有修改，哪怕已经回退了
```

### local --> remote

将本地仓库提交到远程仓库，需要先关联

```bash
git remote add <origin> <git@server-name:path/repo-name.git>
```

```bash
git push -u <origin> <master> # 第一次提交推送所有内容(-u)
git push <origin> <master> # 以后提交只推送最新修改
```

### remote --> local

将远程仓库下载到本地

```bash
git clone <git@server-name:path/repo-name.git>
git clone <http(s)://server-name:path/repo-name.git>
```
