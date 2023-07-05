
# [YANG的阐释](Chapter.3.md)

P80-136(57)

本章以一个书店模型为例, 讲解了如何使用Yang建模业务.  
本章提供了很多建模知识点, 可以作为RFC以外熟悉规则的一个途径.  

3.1 

[bookzone](https://github.com/janlindblad/bookzone)

[本地副本](src/bookzone-master-20211104.zip)

3.2

* 尽可能使用有意义的键, 而不是使用纯粹的数字做标识符
* 每个yang模块开始必须以`module`开头
* 每个yang模块必须有全世界唯一的命名空间, 建议用法:机构URL+机构内ID
* 以`urn:`开头的命名空间应该在互联网编号分配机构(IANA)注册
* `leafref`是指向某个yang列表中leaf列的指针
* `path`是XPath的简化属性, 不能表达所有XPath特性
* 习惯上全部标识符都是小写+连字符`-`, 包括枚举值`enum`
* `union`允许使用多种类型的数据, 其中定义的结构都可以使用
* 使用`identity`建立具有类别关系的枚举的模型, 使用`base`表述继承自何种基础模型, 后缀建议加`-idty`表示是标识符, 用于实记
* `revision`用于描述修正的新内容, 新修正的`revision`放在旧的`revision`之前, 置于文档的头部

3.3

* 客户端发送给服务端的消息叫action或rpc, 服务端发送给客户端的消息叫notification
* rpc的声明只能在yang模型顶层, 而不能在模型某个容器内; rpc的使用只能在容器内, 而不能在模型顶层
* action在yang模型v1.1加入, v1.0不支持
* rpc和action的区别是:对yang模型树的特定节点操作被称为action, 操作不与特定节点相关则称为rpc
* rpc和action在使用时,需要指定`input`和`output`
* 所有的action都可以通过追加到操作对象的`leafref`转换为rpc, 反之则不然; 存在不对任何节点操作的rpc, 比如`rpc reboot`
* `choice`列出多个选项, 满足其中之一即可; 使用`case`来标识选项时, 如备选对象为单个leaf,容器,或列表, 则可跳过`case`
* `choice`和`case`是模式节点, 在模型的数据表示中是不可见的, 在指定节点路径时, 会忽略模式节点
* `output`不设置任何输出也是可以的
* `empty`表示空值, 可以存在也可以不存在, 通常用于表示条件, 表示和success, enabled等状态相反的意思
* notification始终定义在顶层, 在任何容器,列表,和节点之外, 它们不和yang模型的节点相关

3.4

* state表示系统发生事件时生成的一些数据
* `config false`表示该节点对象不可配置, 其节点下属子节点, 容器, 列表等也都不可配置
* 一般节点不写`config false`则默认继承上一级父节点状态, 而默认`module`结点状态为`config true`(除非显式设置为false)
* 使用`key`指定键, 指定多个键时, 使用空格来分隔, 这些键描述在一个字符串边界内(`"`)
* 对于`config false`的节点, 可以没有键, 但这样就不能局部检索, 只能全部获取整个数据列表
* 如非别无选择, 不应该使用无键的列表
* `grouping`用于描述可重复利用的节点内容, 使用`uses`复用它, 复用的方式就是复制一个`grouping`的副本
* `grouping`和`uses`的缺点是复用过多层次过深时, 难以有效追踪

3.5

* 反模式: 对leaf声明为整数或字符串, 但没有准确描述或限制它们
* 反模式: 不描述leaf不存在的场合的含义(对必须使用的场合, 使用`mandatory`声明)
* 反模式: 使用`must`声明直接指向需要测试的leaf(`must`之后接的是XPath, 指向其他位置, 只有表达式值为真, 动作才是有效的)
* XPath中的`deref()`指定括号内的函数做输入
* 使用`unique`做唯一性声明
* `current()`返回`must`声明的元素
* `must`仅指向一个leaf而不做任何比较则为存在性测试
* `not()`用于取负值, 不是传统的逻辑非
* `derived-from(leafpath, "type")`检查引用的leaf是否具有特定类型的值
* yang可能不能描述业务的所有逻辑限制, 需要在yang之外实现
* 反模式: 关注不属于数据的模式节点(使用XPath构建路径时, 仅考虑数据和引用节点, 路径中也忽略各种声明的关键字)

3.6

* 使用`augment`将模块的内容移到另一个模块中, 将指定的内容添加到指定路径后
* `import`在模块中声明另一个模块的存在, 使其可以使用它的内容
* `import`声明前缀, 使用该模块的内容默认具有该前缀
* 拆分成多个模块的主要目的是方便各部分版本控制
* 使用`extension`声明自定义的关键字, 可以携带参数, 但对扩展解析器不一定支持, 确保忽略扩展时模型依旧有效
* 使用`deviation`声明未涵盖的内容, 一般用于模型更新时

3.7

* 区分state和config两种类型的数据
* 有一些系统支持`pre-provisioning`或`preconfiguration`, 可以先接受配置, 下次重启再生效
* 一般对于state和config的区分在于命名, 使用`-state`后缀表示同样配置的状态数据, 这种做法可以简化协议但增加了重复性; 另一种方法是使用NMDA结构, 但对现有模型就必须全部重新设计
* 系统状态中, `:running`是必须的, `:startup`和`:candidate`是可选的, 此外还有`:intended`和`:operational`, 前者包含和`:running`相同的信息, 用于从模板扩展到实例配置的信息, 后者是所有`config false`和`config true`的只读副本
* yang明显是一门上下文相关语言, 而使用XML编码而不是JSON的主要原因是JSON无法表示命名空间
