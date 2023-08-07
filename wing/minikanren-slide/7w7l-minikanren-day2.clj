
;;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; conde
; matche
; defne
; conda
; matcha
; defna
; condu
; matchu
; defnu
; featurec
; all

; 使用matche匹配列表(替代membero)
; (matche ([[pat1]] proc1) ([[pat2]] proc2) ...)

; 重构insideo 1#
(defn insideo [e l]
  (matche [l]
    ([[e . _]])
    ([[_ . t]] (insideo e t) )
  )
)

; 使用defne定义逻辑命题的同时生成匹配(替代每次都附加一个matche)
; (defne name [args] ([[pat1]] proc1) ([[pat2]] proc2) ...)

; 重构insideo 2#
(defne insideo [e l]
  ([_ [e . _]])
  ([_ [_ . t]] (insideo e t))
)

(run* [q] (insideo q [:a :b :c]))
(run 3 [q] (insideo :a q))
(run* [q] (insideo :d [:a :b :c q]))

;;;; 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 对散列表的匹配必须完全一致
(run* [q]
  (fresh [m]
    (== m {:a 1 :b 2})
    (matche [m]
      ([{:a 1}] (== q :found-a))
      ([{:b 1}] (== q :found-b))
      ([{:b 2 :a 1}] (== q :found-a-to-b))
    )
  )
)

; 使用featurec在散列表中构建未绑定的逻辑变量, 实现偏序匹配
(run* [q]
  (fresh [m a b]
    (== m {:a 1 :b 2})
    (conde
      [(featurec m {:a a}) (== q [:found-a a])]
      [(featurec m {:b b}) (== q [:found-b b])]
      [(featurec m {:a a :b b}) (== q [:found-a-and-b a b])]
    )
  )
)

; featurec不构成一个关系, 所以只能正向执行, 反向执行会变成匹配任意散列表(没有意义)
(run* [q] (featurec {:a 1 :b 2 :c 3} q) )

;;;; 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; conde的匹配取得所有结果
(defn whicho [x s1 s2 r]
  (conde
    [(membero x s1) (== r :one)]
    [(membero x s2) (== r :two)]
    [(membero x s1) (membero x s2) (== r :both)]
  )
)

; conda的匹配取得第一个成功的匹配(conda的分支有顺序)
(defn whicho [x s1 s2 r]
  (conda
    [(all (membero x s1) (membero x s2) (== r :both))]
    [(all (membero x s1) (== r :one))]
    [(all (membero x s2) (== r :two))]
  )
)

; all表示要执行所有匹配, 否则完成了第一个部分匹配后续就不执行了, 如果此时失败则无结果
(defn whicho [x s1 s2 r]
  (conda
    [(membero x s1) (membero x s2) (== r :both)] ; 此时单独匹配:a/:b无结果
    [(membero x s1) (== r :one)]
    [(membero x s2) (== r :two)]
  )
)

(run* [q] (whicho :a [:a :b :c] [:d :e :c] q))
(run* [q] (whicho :d [:a :b :c] [:d :e :c] q))
(run* [q] (whicho :c [:a :b :c] [:d :e :c] q))

; condu在匹配到第一个解时就返回结果
(defn insideo [e l]
  (condu
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