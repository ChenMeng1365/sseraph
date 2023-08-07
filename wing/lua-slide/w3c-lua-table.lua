#!/usr/bin/lua

-- [Doc](https://www.lua.org/manual/5.4/)

----------------------------------------------------------------------------------------------------------

-- TIPS: 核心数据单元是表(table), 既可以是列表也可以是散列表
-- TIPS: 检索使用.key和['key']都可以
-- TIPS: 遍历使用pairs()取出每一对(key, val)

list = {key0=0, key255='255'}
list.key1 = 'val1'
list['key2'] = 'val2'

print(list['key0'], list['key1'], list.key2, list.key255)
print(list)

for key, val in pairs(list) do
  print(key,":",val)
end

----------------------------------------------------------------------------------------------------------

-- TIPS: 列表计数从1开始
-- TIPS: 使用#计算列表长度, 使用table.insert(list, index, val)插入数据
-- TIPS: 列表末尾的nil会被忽视, 列表中间的nil会不确定☆

as,ar = {}, {}

for var = 1,10 do
  table.insert(as, var, var) -- 顺序插入
  table.insert(ar, 1, var)   -- 逆序插入
end

print("as num:"..#as, "ar num:"..#ar)
print("index", "as", "ar")

for idx = 1, #as do
  print(idx..": ", as[idx], ar[idx])
end

ary = {1,3,5,7,9,nil}
print(#ary)

ary = {1,3,5,7,9,nil,11}
print(#ary)

ary = {1,3,5,7,9,nil,11, nil, 'nil', nil, 'Nil', nil}
print(#ary)

----------------------------------------------------------------------------------------------------------

-- TIPS: 虽然表可以混用, 但混用时数字优先给列表寻址

a1 = {[1]=1,[2]='2'}
a2 = {3,'4'}
a3 = {[1]=1,[2]='2', 3, '4'}
a4 = {['a']=1,['b']='2', 3, '4'}

print(a1[1], a1[2])
print(a2[1], a2[2])
print(a3[1], a3[2])
print(a4['a'], a4.b, a4[1], a4[2])

----------------------------------------------------------------------------------------------------------