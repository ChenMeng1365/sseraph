
启动postgres
```
docker run -d --restart always --name postgres -p 5432:5432 postgres
```
默认用户postgres/password

修改iptables
```
sudo iptables -R DOCKER x -p tcp -m tcp -s x.x.x.x/24 -d x.x.x.x --dport 5432 -j ACCEPT
```

需要使用时，启动容器msf
```
sudo docker run -it --net host --name msf metasploitframework/metasploit-framework
```