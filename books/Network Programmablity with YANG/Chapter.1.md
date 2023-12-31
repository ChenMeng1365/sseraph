
# [网络管理世界必须改变：为什么你要关心这件事](Chapter.1.md)

P1-45(45)

1.1

FCAPS+E = 故障+配置+计费+性能+安全+能耗

下一代服务交付要求：网络完全自动化和可编程性、业务功能链式部署

1.2 行业趋势

* 缩短部署时间：动态配置下发、冒烟测试
* CLI的问题：无标准化、配置之间依赖性、无结构化输出、错误提示有限，综上发展CLI管理成本高且困难
* 硬件产品化，软硬组装&解耦，降低网络复杂性，专注于业务实现
* Devops：开发+运维
* SDN：FIB+MAC，控制平面分离
* NFV
* 弹性云，按需交付（OpEx）
* 模型驱动MD：模型、协议、实现；NSO网络服务编排器
* 遥测：Telemetry，配置与状态的分离，行为闭环
* 网络基于意图：侧重需求，意图=>配置分解=>自动化=>遥测=>关联分析

1.3

* CLI：可读性，曾经作为API，但缺乏标准化模型，难以维护，极其脆弱
* SNMP：开发维护成本高，信息割裂，批量性能差，缺乏指导文档，发展困难
* Netflow/IPFIX：仅和流量相关，扩展太晚
* Syslog：内容随意性太大，无法自动处理

1.4

下一步：数据模型（一种抽象层次稍低的信息模型）

思路的转变：指示操作模型（减少配置，提高可读性）==>底层基础设施交互（快速自动高质量部署网络，原生自动化，发掘网络的使用价值，减少对成本的聚焦）
