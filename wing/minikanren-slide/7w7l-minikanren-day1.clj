
;;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; clojure下安装minikanren
; org.clojure/core.logic

; > lein new app logic-proj
; > cd logic-proj
; > vi project.clj
;   |> :dependencies [[...] [org.clojure/core.logic "1.0.1"]]
; > lein repl
; > (use 'clojure.core.logic)

; run*
; run
; membero
; conde
; conso
; db-rel
; db
; db-fact
; with-db
; fresh

;;;; 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; run* 查询一组逻辑命题, 返回满足它的所有解
; %1 逻辑变量向量组
; %2+ 逻辑命题
(run* [q] (== q 1))

; membero 查询一个集合中的成员
; %1 逻辑变量
; %2 集合
(run* [q] (membero q [1 2 3]))

; run 查询一组逻辑命题, 返回满足它的部分解
; %1 匹配解数量
; %2 逻辑变量向量组
; %3+ 逻辑命题
(run 2 [q] (membero [1 2 3] q)) ; => (([1 2 3] . _0) (_0 [1 2 3] . _1)) ; .是列表构造符

; conde 查询的逻辑命题之间为or, 满足任一一个即返回它的解
(run* [q]
  (conde
    [(== q 1)]
    [(== q 4) (== q 13)]
    [(== q 7)]
  )
)

; conso 类似于cons构造列表, conso可以构造逻辑命题
(run* [q]
  (conso :a [:b :c] q)
)

;;;; 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 使用内置的关系数据库
(use 'clojure.core.logic.pldb)

; 创建关系, 一般结尾加一个o后缀标明这是一个关系
(db-rel topic1o x)
(db-rel topic2o x)

; 构造命题
(def facts
  (db
  [topic1o :a]
  [topic1o :b]
  [topic1o :c]
  [topic2o :A]
  [topic2o :B]
  [topic2o :C]
  )
)

; 查找关系
(with-db facts
  (run* [q] (topic2o q))
)

; 更新命题
(db-rel topic3o x y)
(def facts
  (-> facts
    (db-fact topic3o :a 14)
    (db-fact topic3o :b 25)
    (db-fact topic3o :c 7)
  )
)

; fresh 在列表中构建未绑定的逻辑变量
(with-db facts
  (run* [q]
    (fresh [a b]
      (topic1o a)
      (topic3o a b)
      (== q [a b])
    )
  )
)

;;;; 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 当逻辑命题反向执行时

(run* [q] (conso :a q [:a :b :c]) )

(run* [q] (fresh [h t] (conso h t [:a :b :c]) (== q [h t]) ))

; 实现membero相同功能的函数
(defn insideo [e l]
  (conde
    [(fresh [h t]
      (conso h t l)
      (== h e)
    )]
    [(fresh [h t]
      (conso h t l)
      (insideo e t)
    )]
  )
)
(run* [q] (insideo q [:a :b :c]))
(run 3 [q] (insideo :a q)) ; 反向求构造
(run* [q] (insideo :d [:a :b :c q])) ; 反向求成员
