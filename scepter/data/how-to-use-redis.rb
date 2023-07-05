#coding:utf-8
require 'yaml'
require 'json'
require 'redis'

# http://www.redis.cn/commands.html
# https://www.rubydoc.info/gems/redis/4.0.1

begin
  c = YAML.load(File.read("../../warehouse/database/redis-config.yml"))
  redis = Redis.new(
    url: "redis://#{c['user']}:#{c['pswd']}@#{c['host']}:#{c['port']}",
    connect_timeout: 0.2,
    read_timeout: 1.0,
    write_timeout: 0.5
  )
end

begin # basic
  redis.set("misc", "boo")
  redis.set "misc", [1, 2, 3].to_json
  puts redis.get("misc")
end

begin # independent
  redis.set('misc',1)
  redis.pipelined do
    @set = redis.set "foo", "bar" # futures
    @incr = redis.incr "misc"
  end
  puts redis.get("misc")
  puts @set.value
  puts redis.get("foo")
  puts @incr.value
end

begin # atomic
  redis.multi do
    redis.set "foo", "bar"
    redis.incr "misc"
  end
end

