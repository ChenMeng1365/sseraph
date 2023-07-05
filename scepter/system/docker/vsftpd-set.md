
### running

```
sudo docker run -itd -v #{HOST_PATH}:/home/vsftpd \
 -p #{HOST_PORTRANGE}:#{PARA_PORTRANGE} \
 -e FTP_USER=#{USERNAME} -e FTP_PASS=#{PASSWORD} \
 -e PASV_ADDRESS=#{DOCKER_GW_ADDRESS} \
 -e PASV_MIN_PORT=#{MINPORT} -e PASV_MAX_PORT=#{MAXPORT} \
 --name #{FTP_SVR_NAME} --restart=always fauria/vsftpd
```

注意用户和空间管理