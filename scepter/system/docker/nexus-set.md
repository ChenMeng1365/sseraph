
```
mkdir -p /home/base/nexus
chmod 777 /home/base/nexus
```

```
sudo docker run -d -p 8082:8081 --name nexus \
                -v /home/base/nexus:/nexus-data  \
                -e INSTALL4J_ADD_VM_PARAMS="-Xms1g -Xmx1g -XX:MaxDirectMemorySize=1g" \
                sonatype/nexus3
```
由于制品库相对独立，可以不放在几大容器互通的网络里

```
sudo docker exec nexus cat /nexus-data/admin.password
```
用admin登录后更换密码为自己熟悉的密码

```
sudo iptables -L -n --line
sudo iptables -R DOCKER 7 -p tcp -m tcp -s x.x.x.x/xx -d 172.17.0.2 --dport 8081 -j ACCEPT
```