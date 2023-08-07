
;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; STM 软件事务内存, 在处理并发时, 每个事务拥有自己的私有数据, 维持多个版本的一致性和完整性

(def a (ref "a")) ; a是一个引用
a
(deref a) ; 查看a的值
@a

(dosync (alter a str "A")) ; 修改a的操作必须在事务内进行
(dosync (ref-set a "Z"))

;;; 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; atom 原子, 适用于单个引用不和其他活动同步的场合

(def b (atom ["b"]))
@b

(swap! b conj {:a "a" :b "b"})
(reset! b ["Z"])

; 原子缓存思想: 将状态变化封装成包, 用函数来修改
(defn create [] (atom {}))
(defn get [cache key] (@cache key))
(defn put 
  ([cache vmap] (swap! cache merge vmap))
  ([cache key value] (swap! cache assoc key value))
)

(def ac (create))
(put ac :quote "ac")
(println (get ac :quote))

;;; 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 使用代理, 一直阻塞到值可用为止
; 从引用, 代理, 原子中读取值永远不会锁定和阻塞
(def tribbles (agent 1))

(defn twice [x] (* 2 x))
(send tribbles twice)
@tribbles

(defn slow-twice [x] (do (Thread/sleep 5000) (* 2 x)))
(send tribbles slow-twice)
@tribbles
@tribbles ; 间隔一段时间再观察

; await 由于读是立刻的, 所以可能不是最新值, 所以使用等待获取最新值
(send tribbles slow-twice)
(await tribbles)
(awaitfor timeout tribbles)
@tribbles

;;; 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; future 创建另一线程立刻计算但不等待结果, 实现异步返回
(def finer (future (Thread/sleep 5000) "take 5 seconds"))
@finer ; future新建的线程阻塞了, 但主线程不受影响, 除非取该引用的值
