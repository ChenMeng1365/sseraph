
;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; clojure受限JVM, 尾递归优化必须显式调用loop, recur
; (loop [x x-init-val, y y-init-val, ...] (do-something x y ...))
; (recur new-x new-y ...)
(defn size [vct]
  (loop [lst vct, cnt 0]
    (if (empty? lst)
      cnt
      (recur (rest lst) (inc cnt))
    )
  )
)

;;; 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 序列方法(列表, 向量, 集合, 映射表)

; every? 检查序列中所有元素
(every? number? [1 2 3 :four])

; not-every? 检查序列中某些元素(否定命题)
(not-every? odd? [1 3 5])

; some 检查序列中某些元素
(some nil? [1 2 nil 3]) ; some返回第一个非nil和false的值

; not-any? 检查序列中所有元素(否定命题)
(not-any? number? [:one :two :three])

; filter 过滤器, 筛选符合要求的元素
(filter (fn [word] (<= (count word) 6)) ["getter" "setter" "reader" "writer" "accessor"])

; map 映射器, 将函数应用到每个元素上
(map (fn [x] (* x x)) [1 1 2 3 5])

; for 复用器, 将每个元素应用到函数上
(for [
    x ["red" "blue"], y ["block" "car"], ; 可以组合任意多个序列
    :when ( (fn [w] (< (count w) 4)) y) ; 可以加列表过滤选项
  ]
  (str "I like " x " " y ".")
)

; reduce 归纳器, 将函数计算结果合一
(reduce + [1 2 3 4])

; 排序
(sort [3 1 4 2])
(sort-by (fn [n] (if (< n 0) (- n) n)) [-1 -4 3 2])

;;; 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; range 创建范围序列
(range 1 10 3) ; 左闭右开, 步长为3, 默认0开始

; take 取无限循环的一部分
; 无限序列是延迟估值的, 只在计算时得出实例
(take 5 (repeat :hi))
(take 5 (cycle [:a :b :c]))
(take 5 (iterate dec 0))

; interpose 向序列中插入元素
(interpose :& [:a :b :c])

; interleave 两个序列元素交织排列
(take 20 (interleave (cycle [:a :b :c]) (cycle [\A \Z])))

; drop 丢弃n个元素
(drop 2 [:a :b :c :d :e])

; 利用延迟估值的无限序列构造扩张递归(注意性能)
(defn fib-pair [[a b]] [b (+ a b)])
(nth (map first (iterate fib-pair [1 1])) 50)

(defn factorial [n] (apply * (take n (iterate inc 1))))
(factorial 20)

;;; 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 结合JVM扩展clojure
; defrecord 定义类型
; defprotocol 定义协议, 围绕类型组织函数

(defprotocol Compass
  (direction [c])
  (left [c])
  (right [c])
)

(def directions [:north :east :south :west])

(defn turn [base amount] 
  (rem (+ base amount) (count directions))
)

(turn 1 1)
(turn 3 1)
(turn 2 3)

(defrecord SimpleCompass [bearing]
  Compass
  (direction [_] (directions bearing))

  ; (SomeType. arg) 调用某类型的构造函数并绑定arg到第一个参数上
  (left [_] (SimpleCompass. (turn bearing 3)))
  (right [_] (SimpleCompass. (turn bearing 1)))

  Object
  (toString [this] (str "[" (direction this) "]"))
)

(def c (SimpleCompass. 0))
(left c)
(:bearing c)

;;; 5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; defmacro 定义宏, 就像定义函数一样, 用数据表示代码, 用引用号'引起来
(defmacro unless [cond body] (list 'if (list 'not cond) body))

; macroexpand 宏展开, 将宏变换成它原本的模样
(macroexpand ''something-to-do)
(macroexpand '#(count %))

(macroexpand '(unless cond body))
(unless false (println "The False Case."))
