
# fork

当需要克隆他人的代码同时又要保持提交关系时就可以用到fork。

1. fork对方的仓库，这会在自己的工作区生成一个一模一样的仓库。
2. clone自己的同名仓库，`git clone https://github.com/YOU/YOUR_REPO.git`
3. 给本地仓库添加关联，`git remote add upstream https://github.com/AUTHOR/HIS_REPO.git`

查看本地仓库的关联关系

```shell
git remote -v
> origin    https://github.com/YOU/YOUR_REPO.git (fetch)
> origin    https://github.com/YOU/YOUR_REPO.git (push)
> upstream  https://github.com/AUTHOR/HIS_REPO.git(fetch)
> upstream  https://github.com/AUTHOR/HIS_REPO.git(push)
```

这样可以保证从上游仓库拉到最新代码和分支

```shell
git fetch upstream
git rebase upstream/master
git push origin master
```

提交

```shell
git add .
git commit -m 'COMMENT' --amend # 确保提交只有一次, 首次提交带签名(-S)
git push --force-with-lease # 强制推送到自己的仓库
```
