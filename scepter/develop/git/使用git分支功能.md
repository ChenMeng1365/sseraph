

## 分支

主分支: master，每个仓库必有一个主分支。

远程分支：origin，远程仓库的默认分支。

其他分支：名字自定义，一些常用的约定命名：

* 开发：dev

* 测试：test

* 修复：issue

* 生产：prod

查看当前分支

```bash
git branch
git remote # 远程仓库信息，-v详细信息
```

会列出所有分支，在当前分支前有一个'\*'，HEAD用以指代当前分支的最近修改。

## 创建分支

```bash
git checkout -b <branchname> # 创建一个分支，并切换到该分支
```

它等效于如下操作

```bash
git branch <branchname>
git checkout <branchname>
```

## 切换分支

```bash
git checkout <branchname>
 ```

## 合并分支

将指定分支的内容合并到当前分支

```bash
 git merge <branchname>
 ```

当两个分支合并无冲突时，可以快速合并(Fast-forward)，这种模式在删除分支后会丢掉分支信息

如要禁用快速合并，使用--no-ff选项，这种模式适合长期分支开发，记录了每次合并的历史

```bash
git merge --no-ff -m "message" <branchname>
```

当两个分支各有修改提交时，会产生冲突(CONFLICT)，需要人工处理冲突(修改冲突内容)

```
<<<<<<< HEAD
# 当前分支的内容
=======
# 另一分支的内容
>>>>>>> <branchname>
```

使用堆栈图描述合并情况

```bash
git log --graph --pretty=oneline --abbrev-commit
```

## 推送分支

将本地分支推送到远程仓库

```bash
git push origin master
git push <remote> <branchname>
```

如果多人合作提交，可能会有冲突，这时需要先将代码抓到本地，本地手工合并解决冲突后再推送

```bash
git pull <remote> <branchname>
git branch --set-upstream-to=origin/<branchname> <branchname>
```

## 删除分支

分支合并后可以销毁不再使用的分支

```bash
git branch -d <branchname>
git branch -D <branchname> # 强行删除
```

## 分支的应用

修复某个分支的bug
```bash
git branch
git checkout -b <issue-xxx>
```