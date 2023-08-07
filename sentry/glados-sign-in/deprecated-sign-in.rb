#coding:utf-8
require 'webot'

authorization = ""

cookie = {
  "koa:sess" => "",
  "koa:sess.sig" => "",
  "_gid" => "",
  "_ga_CZFVKMNT9J" => "",
  "_ga" => "",
  "_gat_gtag_UA_104464600_2" => ""
}.inject([]){|lst,kv|k,v=kv;lst<<"#{k}=#{v}";lst}.join("; ")

# 'https://glados.rocks/api/user/checkin'
option = {
  https: true,
  url: 'glados.rocks',
  path: '/api/user/checkin',
  headers: {
    "Content-Type" => "application/json, text/plain, */*",
    "Accept" => "application/json, text/plain, */*",
    "Accept-Encoding" => "deflate",
    "Accept-Language" => "zh-CN,zh;q=0.9",

    "Authorization" => authorization,
    "Cookie" => cookie,

    "Origin" => "https://glados.rocks",
    'Sec-Fetch-Dest'=> "empty",
    'Sec-Fetch-Mode'=> "cors",
    'Sec-Fetch-Site'=> "same-origin",
    'Sec-Ch-Ua'=> '"Not.A/Brand";v="8", "Chromium";v="114", "Google Chrome";v="114"',
    'Sec-Ch-Ua-Mobile'=> "?0",
    'Sec-Ch-Ua-Platform'=> "Windows",
    "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
  },
  data: {token: "glados.network"}
}

result = Webot.post(option)
puts result['body']
