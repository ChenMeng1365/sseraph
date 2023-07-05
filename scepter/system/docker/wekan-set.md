
### compose
```
version: '2'
services:
  wekan-db:
    #-------------------------------------------------------------------------------------
    image: mongo:3.2.20
    #-------------------------------------------------------------------------------------
    container_name: wekan-db
    restart: always
    command: mongod --smallfiles --oplogSize 128
    #-------------------------------------------------------------------------------------
    ports:
      - 27017:27017
    networks:
      - 99net
    expose:
      - 27017
    volumes:
      - /home/base/wekan/data:/data/db
      - /home/base/wekan/dump:/dump
  wekan-app:
    #-------------------------------------------------------------------------------------
    image: wekanteam/wekan:v2.17
    #-------------------------------------------------------------------------------------
    container_name: wekan-app
    restart: always
    #-------------------------------------------------------------------------------------
    networks:
      - 99net
    ports:
      - 2000:8080
    environment:
      - MONGO_URL=mongodb://wekan-db:27017/wekan
      - ROOT_URL=http://code.numeron.net:2000
      - WITH_API=true
      - BROWSER_POLICY_ENABLED=true
    depends_on:
      - wekan-db
networks:
  99net:
    driver: bridge
```

### running
```
sudo docker-compose up -d
```

### iptables
```
sudo iptables -L -n --line
sudo iptables -R DOCKER 3 -p tcp -m tcp -s x.x.x.x/xx -d 172.20.0.2 --dport 27017 -j ACCEPT
sudo iptables -R DOCKER 4 -p tcp -m tcp -s x.x.x.x/xx -d 172.20.0.3 --dport 8080 -j ACCEPT
```