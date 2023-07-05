
### Not advise
```
sudo mkdir -p /home/base/jenkins
sudo chown -R 1000:1000 jenkins # 必须修改
sudo docker run -itd -p 8080:8080 -p 50000:50000 --name jenkins --privileged=true  -v 
```
```
/home//jenkins:/var/jenkins_home jenkins
```

第一次访问初始化
```
cat /home/base/jenkins/secrets/initialAdminPassword
```
创建admin账号密码

建议自己写镜像，官方版本太低了