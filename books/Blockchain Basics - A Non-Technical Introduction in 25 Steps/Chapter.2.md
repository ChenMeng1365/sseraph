---

---

<!-- # 为什么这个世界需要区块链 -->

---

# 4. 发现核心问题

---

完备性与信任是点对点系统设计者主要考虑的事情

如果人们信任一个点对点系统，就会加入进来做出贡献，如果从系统得到正反馈，就会进一步加深这种信任

如果人们对一个点对点系统失去了信任，就会放弃这个系统，最后导致系统的终结

---

点对点系统的完备性主要威胁是：

- 技术性故障
- 恶意节点

点对点系统实现完备性取决于：

- 对节点数量的了解
- 对节点可信度的了解

---

区块链解决的问题就是，对由未知可信度节点组成的完全去中心化点对点系统，如何实现并确保其系统完备性

---

## 5. 消除术语的歧义

---

区块链可以是：

- 一种数据结构
- 一种算法
- 一个完整的技术方案
- 一类完全去中心化的点对点系统

---

管理和区分所有权是区块链的一个应用场景，但不是唯一的一个

完全分布式点对点账本系统利用特殊算法实现对区块内信息生成顺序的协调，并使用加密几乎对区块数据进行连接，从而确保系统的完备性

---

# 6. 理解所有权的本质

---

所有权证明需要三个要素：

- 对所有者的证明
- 对事物被拥有的证明
- 所有者和事物之间的连接

使用ID来标识所有者，使用ID、时间和空间证明、详细描述来标识事物

所有者和事物的联系可以保存在账本中，就像法庭上证人证物证词那样

---

只使用一个账本是有风险的，它可能损坏或被伪造；可以使用一组独立的账本而不是一个中央账本来记录所有权，使用大多数账本认可的结果来进行所有权证明

通过区块链数据结构创建完全去中心化的系统账本，每个节点上的区块链数据表示一个账本，区块链算法负责让各个节点的账本内所有权状态同步到一个一致的版本

完全去中心化点对点账本系统证明了正确的所有权并确保合法所有者才能转移资产，从而证明其完备性

---

# 7. 双花问题

---

双花问题是：

- 复制数字资产时引起的问题
- 去中心化系统中可能存在的问题（系统同步时导致）
- 威胁去中心化系统的一种情形（违反数据一致性）

双花问题是完全去中心化点对点系统的潜在威胁，区块链是解决它的一种手段
