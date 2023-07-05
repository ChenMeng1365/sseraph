
# The YANG 1.1 Data Modeling Language

[目录](https://datatracker.ietf.org/doc/html/rfc7950#page-3)

[](https://datatracker.ietf.org/doc/html/rfc7950#page-)
[](https://datatracker.ietf.org/doc/html/rfc7950#section-)

## [1](https://datatracker.ietf.org/doc/html/rfc7950#section-1). [介绍](https://datatracker.ietf.org/doc/html/rfc7950#page-9)

## [2](https://datatracker.ietf.org/doc/html/rfc7950#section-2). [关键词](https://datatracker.ietf.org/doc/html/rfc7950#page-12)

## [3](https://datatracker.ietf.org/doc/html/rfc7950#section-3). [术语](https://datatracker.ietf.org/doc/html/rfc7950#page-12)

## [4](https://datatracker.ietf.org/doc/html/rfc7950#section-4). [概览](https://datatracker.ietf.org/doc/html/rfc7950#page-16)

## [5](https://datatracker.ietf.org/doc/html/rfc7950#section-5). [语言概念](https://datatracker.ietf.org/doc/html/rfc7950#page-32)

---

### 5.6 一致性

应用程序和模型的一致性分为三个层面:

- 模型的基本行为
  > 定义双端的语义和语法的合约
- 模型的部分可选特征
  > 部分模型的成立是有条件的, 由服务端判断条件是否成立
  > 这部分被描述为特征(使用feature), 只有满足适当条件时,才表现出这种特征
  > 特征的条件由if-feature定义
- 和模型的偏差
  > 部分模型的特征仅仅存在于理想情况, 实际运行中会有差异
  > 使用deviation描述这种差异, 定义见[7.20.3]

netconf中的一致性:

- netconf服务端必须通过"/modules-state/module"列出所有实现的ietf-yang-library模块(参看[RFC7895](https://datatracker.ietf.org/doc/html/rfc7895))
- 在hello消息中需要通告如下能力
  > urn:ietf:params:netconf:capability:yang-library:1.0?
    revision=\<date>&module-set-id=\<id>
  > revision是模块修正日期, module-set-id是"/modules-state/module-set-id"节点的值
  > 客户端可以缓存该节点的值, 直到module-set-id更新

实现模块的条件:

- 数据节点, RPC, 动作, 偏差
- 一个模块不能存在多个实现版本
- 如果模块A引入了模块B(import), 通过augment或path引用到了B的数据节点, 则服务端必须实现模块B的相应revision
- 如果模块A引入了模块C, 但没有指定revision日期, 服务端没有实现C, 则服务端必须在"/modules-state/module"中列出C, 并且设置其conformance-type为import
- 如果模块M引入了模块C, 但没有指定revision日期, 服务端必须使用C的最新版本给M

p41-44给出的一个示例应用了上述几条规则

上述所有原则都围绕着使客户端能知道所有leaf和leaf-list的数据结构和类型而来

---

## [6](https://datatracker.ietf.org/doc/html/rfc7950#section-6). [语法](https://datatracker.ietf.org/doc/html/rfc7950#page-44)

## [7](https://datatracker.ietf.org/doc/html/rfc7950#section-7). [语句](https://datatracker.ietf.org/doc/html/rfc7950#page-55)

---

### 7.20.3 deviation语句

**deviation语句**描述了服务端没有完全执行模型的偏差内容

参数是一个节点标识符的绝对模式(schema)

偏差不应成为已发布的标准, 偏差仅仅只作为服务端不遵守模块处理时最后的一种解释手段

比如某些情况下, 设备不具备某些硬件或软件特性, 此时服务端会尝试报配置错误, 或者忽略异常请求, 但这两个都不是好的选择

相对地, 可以通过偏差列举一些模块不支持, 或者支持但有不同于基本模块的句法, 全部列出偏差后, 数据模型的任何结构都是有效的

  | deviation的子句 | 章节     | 可选数量 |
  | --------------- | -------- | -------- |
  | description     | 7.21.3   | 0..1     |
  | deviate         | 7.20.3.2 | 1..n     |
  | reference       | 7.21.4   | 0..1     |

**deviate语句**描述了服务端如何偏离目标节点, 有四种情况:

- not-supported: 服务端不支持该节点
- add: 向该节点添加属性, 属性由子句定义, 如果只能添加一次, 则重复添加无效
- replace: 替换节点的某属性, 属性由子句定义, 该节点必须存在该属性才能替换
- delete: 删除节点的某属性, 属性由子句定义, 其关键字必须与节点对应关键字相等

p133-134例子对应上述情况

| deviate的子句 | 章节         | 可选数量 |
| ------------- | ------------ | -------- |
| config        | 7.21.1       | 0..1     |
| default       | 7.6.4, 7.7.4 | 0..n     |
| mandatory     | 7.6.5        | 0..1     |
| max-elements  | 7.7.6        | 0..1     |
| min-elements  | 7.7.5        | 0..1     |
| must          | 7.5.3        | 0..n     |
| type          | 7.4          | 0..1     |
| unique        | 7.8.3        | 0..n     |
| units         | 7.3.3        | 0..1     |

一个目标节点的属性定义了扩展(extension), 如果扩展允许偏差, 则属性允许偏差(使用deviate), 具体参见[7.19]

---

## [8](https://datatracker.ietf.org/doc/html/rfc7950#section-8). [约束性规则](https://datatracker.ietf.org/doc/html/rfc7950#page-138)

## [9](https://datatracker.ietf.org/doc/html/rfc7950#section-9). [内置类型](https://datatracker.ietf.org/doc/html/rfc7950#page-141)

## [10](https://datatracker.ietf.org/doc/html/rfc7950#section-10). [XPath函数](https://datatracker.ietf.org/doc/html/rfc7950#page-170)

## [11](https://datatracker.ietf.org/doc/html/rfc7950#section-11). [模块更新](https://datatracker.ietf.org/doc/html/rfc7950#page-176)

## [12](https://datatracker.ietf.org/doc/html/rfc7950#section-12). [与YANG.ver1共存问题](https://datatracker.ietf.org/doc/html/rfc7950#page-179)

---

## [13](https://datatracker.ietf.org/doc/html/rfc7950#section-13). [YIN](https://datatracker.ietf.org/doc/html/rfc7950#page-179)

p179-183

YIN是YANG无损的信息转换方式  
YANG关键字对应元素的命名空间URI是`urn:ietf:params:xml:ns:yang:yin:1`  
YIN元素名称必须符合[XML命名机制](https://www.w3.org/TR/2009/REC-xml-names-20091208)

通过XML属性或是一个关键字的子元素来表示一个元素的名称, 相关参看[extension]语句(https://datatracker.ietf.org/doc/html/rfc7950#section-7.19)  

一般使用XML属性`name`表示一个元素的名称  

但如下节点根据语义变更了元素名称的命名:
`config`,`default`,`deviate`,`error-app-tag`,`error-message`,`fraction-digits`,`key`,`length`,`mandatory`,`max-elements`,`min-elements`,`modifier`,`ordered-by`,`path`,`pattern`,`position`,`prefix`,`presence`,`range`,`require-instance`,`status`,`value`,`yang-version`,`yin-element`使用`value`
`augment`,`deviation`,`refine`使用`target-node`
`belongs-to`,`import`,`include`使用`module`
`revision`,`revision-date`使用`date`
`must`,`when`使用`condition`
`namespace`使用`uri`
`unique`使用`tag`

如下节点使用子元素来表示名称, 文本即为内容:
`contact`,`description`,`organization`,`reference`

`input`,`output`没有元素名称, 不需要命名

对于参数:  
如果表示一个属性, 则这个属性没有命名空间  
如果表示一个元素, 则它具有和父元素同样的命名空间  
如果表示一个元素, 则它必须是父元素的第一个子元素

`substatement`语句表现为关键字的子元素, 它们之间的顺序和YANG模型中一模一样

YANG中的注释表现为XML注释

---

## [14](https://datatracker.ietf.org/doc/html/rfc7950#section-14). [YANG的ABNF语法](https://datatracker.ietf.org/doc/html/rfc7950#page-184)

## [15](https://datatracker.ietf.org/doc/html/rfc7950#section-15). [YANG相关的NETCONF错误响应](https://datatracker.ietf.org/doc/html/rfc7950#page-211)

## [16](https://datatracker.ietf.org/doc/html/rfc7950#section-16). [IANA事项](https://datatracker.ietf.org/doc/html/rfc7950#page-213)

## [17](https://datatracker.ietf.org/doc/html/rfc7950#section-17). [安全事项](https://datatracker.ietf.org/doc/html/rfc7950#page-213)

## [18](https://datatracker.ietf.org/doc/html/rfc7950#section-18). [参考](https://datatracker.ietf.org/doc/html/rfc7950#page-214)
