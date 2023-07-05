
# 生成SSL证书并自签

```shell
# 1.生成一个RSA密钥
[root@node109 workspace]# openssl genrsa -des3 -out node109.key 2048
Generating RSA private key, 2048 bit long modulus
...........................+++
....................................+++
e is 65537 (0x10001)
Enter pass phrase for node109.key: <输入密码>
Verifying - Enter pass phrase for node109.key: <再次输入密码>

# 2.生成一个不需要密码的密钥文件
[root@node109 workspace]# openssl rsa -in node109.key -out node109_nopswd.key
Enter pass phrase for node109.key:
writing RSA key

# 3.生成一个证书请求
[root@node109 workspace]# openssl req -new -key node109.key -out node109.csr
Enter pass phrase for node109.key: <输入刚才的密码>
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:<国家代码>
State or Province Name (full name) []:<省份>
Locality Name (eg, city) [Default City]:<城市>
Organization Name (eg, company) [Default Company Ltd]:<机构>
Organizational Unit Name (eg, section) []:<部门>
Common Name (eg, your name or your server's hostname) []:<域名>
Email Address []:<邮箱>

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:<直接回车>
An optional company name []:<直接回车>

# 4.自己签发证书
[root@node109 workspace]# openssl x509 -req -days 3650 -in node109.csr -signkey node109.key -out node109.crt
Signature ok
subject=/C=CN/ST=HB/L=XG/O=CT/OU=OC/CN=node109.numeron.net/emailAddress=18995691365@189.cn
Getting Private key
Enter pass phrase for node109.key:
```

一般的证书需要到专门的认证机构（比如[VeriSign](http://www.verisign.com/cn/)）申请，需要支付一定的费用，这里第4步自己生成了证书，直接在服务端应用

第2步可以生成不需要密码的key，如果直接用第1步的key则启动网站时会提示输入密码
