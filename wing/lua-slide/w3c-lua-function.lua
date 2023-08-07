#!/usr/bin/lua

-- [Doc](https://www.lua.org/manual/5.4/)

----------------------------------------------------------------------------------------------------------

-- TIPS: 基本函数

-- function act(arg)
--   print(arg)
-- end

-- act("zzZ")

----------------------------------------------------------------------------------------------------------

-- TIPS: 函数是一等公民, 可以赋值具名
-- TIPS: 两种写法: var = function() end 或 function var() end

handler = {}
handler.call = function (arg)
  print(arg)
end

function handler.cast(arg)
  print(arg)
end

handler.call('calling')
handler.cast('casting')

----------------------------------------------------------------------------------------------------------

-- TIPS: 表即是对象, 拷贝对象会复制对象的元素, 包括函数

handler[1] = '1'

function copy(proto)
  local clone = {}
  for k,v in pairs(proto) do
    clone[k] = v
  end
  return clone
end

agent = copy(handler)
print(agent[1])
agent.call('agent calling')
agent.cast('agent casting')

----------------------------------------------------------------------------------------------------------

-- TIPS: 通过拷贝原型模仿对象生成器new
-- TIPS: 原型线索self, 使用:对其隐藏

handler.new = function (name)
  local self = copy(handler)
  self.name = name
  return self
end

newbeing = handler.new('newbeing')
newbeing.call('newbeing calling')
newbeing.cast('newbeing casting')

newbeing.merb = function(self)
  print("merbing..."..self.name)
end

newbeing.merb(newbeing)
newbeing:merb()

----------------------------------------------------------------------------------------------------------

-- TIPS: NIF方法copy(proto, new)拷贝对象

being = {}
being.new = function(name)
  local self = newbeing.new(name)
  copy(self, being)
  return self
end

twobeing = being.new('2being')
twobeing.call('2being calling')
print(twobeing.merb) -- newbeing.merb是后来赋予的, 拷贝时不会赋给twobeing

----------------------------------------------------------------------------------------------------------

-- TIPS: 通过原型模仿类构造器

function Object(name)
  local self = {}

  local function init()
    self.name = name
  end

  self.merb = function ()
    print('merb...'..self.name)
  end

  init()
  return self
end

newobj = Object('newobj')
newobj:merb()

----------------------------------------------------------------------------------------------------------

-- TIPS: 继承的特性, 父类方法会被执行, 成为装饰器

function Succeed(name)
  local self = Object(name)

  local function init()
    self.name = self.name .. 'ess'
  end

  init()
  return self
end

succ = Succeed('newsucc')
succ:merb()
