
# Create

## 创建节点

```cepher
CREATE (<node-name>:<label-name>: ...)
```

# Read

## 查询节点

```cepher
MATCH 
(
   <node-name>:<label-name>
)
RETURN 
   <node-name>.<property1-name>,
   ........
   <node-name>.<propertyn-name>
```

## 查询孤立的节点

```cepher
match (x) return x
```

## 查询有关系的节点

```cepher
match (x)-[r]-(y) return x,r,y
```

## 查询自环的节点

```cepher
match (x)-[r]-(x) return x,r
```

# Update

# Delete

## 删除节点

```cepher
MATCH 
(
   <node-name>:<label-name>
)
DELETE <node-name>
```

## 删除所有节点

```cepher
match (x) delete x
```

## 删除所有关系

```cepher
match (x)-[r]-(y) delete r
```

## 删除所有关系和节点

```cepher
match (x)-[r]-(y) delete x,r,y
```
