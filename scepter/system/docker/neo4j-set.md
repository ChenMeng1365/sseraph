
```
sudo mkdir -p /home/base/neo4j
```

```
sudo docker run --name neo-lab --network 99net --network-alias neo-lab -d \
                --publish=7474:7474 --publish=7687:7687 \
                --volume=/home/base/neo4j:/data \
                neo4j
```
网页登录7474端口后修改密码，默认neo4j/neo4j

开启web界面后通过7687交互
还有一个7473端口给https用，可开可不开
```
sudo iptables -L -n --line
sudo iptables -R DOCKER 5 -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.4 --dport 7687 -j ACCEPT
sudo iptables -R DOCKER 6 -p tcp -m tcp -s x.x.x.x/xx -d 172.18.0.4 --dport 7474 -j ACCEPT
```