
;;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 使用fd为逻辑变量限定在有限域中求解
(require '[clojure.core.logic.fd :as fd])

(run* [q]
  (fd/in q (fd/interval 0 10))
  (fd/<= q 1)
)

(run* [q]
  (fresh [x y z a]
    (== q [x y z])
    (fd/in x y z a (fd/interval 1 100))
    (fd/distinct [x y z])
    (fd/< x y)
    (fd/< y z)
    (fd/+ x y a)
    (fd/+ a z 100)
  )
)

; 不使用中间变量
(run* [q]
  (fresh [x y z]
    (== q [x y z])
    (fd/in x y z (fd/interval 1 100))
    (fd/distinct [x y z])
    (fd/< x y)
    (fd/< y z)
    (fd/eq (= (+ x y z) 100))
  )
)

;;;; 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 故事推导

(def story-elements
  [
    [:maybe-telegram-girl :telegram-girl "A singing telegram girl arrives."]
    [:maybe-motorist :motorist "A stranded motorist comes asking for help."]
    [:motorist :policeman "Investigating an abandoned car, a policeman appears."]
    [:motorist :dead-motorist "The motorist is found dead in the lounge, killed by a wrench."]
    [:telegram-girl :dead-telegram-girl "The telegram girl is murdered in the hall with a revolver."]
    [:policeman :dead-policeman "The policeman is killed in the library with a lead pipe."]
    [:dead-motorist :guilty-mustard "Colonel Mustard killed the motorist, his old driver during the war."]
    [:dead-motorist :guilty-scarlet "Miss Scarlet killed the motorist to keep her secrets safe."]
    [:dead-motorist :guilty-peacock "Mrs. Peacock killed the motorist."]
    [:dead-telegram-girl :guilty-scarlet "Miss Scarlet killed the telegram girl so she wouldn't talk."]
    [:dead-telegram-girl :guilty-peacock "Mrs. Peacock killed the telegram girl."]
    [:dead-telegram-girl :guilty-wadsworth "Wadsworth shot the telegram girl."]
    [:dead-policeman :guilty-scarlet "Miss Scarlet tried to cover her tracks by murdering the policeman."]
    [:dead-policeman :guilty-peacock "Mrs. Peacock killed the policeman."]
    [:mr-boddy :dead-mr-boddy "Mr. Boddy's body is found in the hall beaten to death with a candlestick."]
    [:dead-mr-body :guilty-plum "Mr. Plum killed Mr. Boddy thinking he was the real blackmailer."]
    [:dead-mr-body :guilty-scarlet "Miss Scarlet killed Mr. Boddy to keep him quiet."]
    [:dead-mr-body :guilty-peacock "Mrs. Peacock killed Mr. Boddy."]
    [:cook :dead-cook "The cook is found stabbed in the kitchen."]
    [:dead-cook :guilty-scarlet "Miss Scarlet killed the cook to silence her."]
    [:dead-cook :guilty-peacock "Mrs. Peacock killed her cook, who used to work for her."]
    [:yvette :dead-yvette "Yvette, the maid, is found strangled with the rope in the billiard room."]
    [:dead-yvette :guilty-scarlet "Miss Scarlet killed her old employee, Yvette."]
    [:dead-yvette :guilty-peacock "Mrs. Peacock killed Yvette."]
    [:dead-yvette :guilty-white "Mrs. White killed Yvette, who had an affair with her husband."]
    [:wadsworth :dead-wadsworth "Wadsworth is found shot dead in the hall."]
    [:dead-wadsworth :guilty-green "Mr. Green, an undercover FBI agent, shot Wadsworth."]
  ]
)

(db-rel ploto a b)

(def story-db
  (reduce
    (fn [dbase elems] (apply db-fact dbase ploto (take 2 elems)) )
    (db)
    story-elements
  )
)

; 只列出会被消费的资源(消费即经过变化后原本资源消失了, 生成了新的资源, 又或称之为初始状态)
(def start-state
  [:maybe-telegram-girl :maybe-motorist :wadsworth :mr-boddy :cook :yvette]
)

; 动作的生成器
(defn actiono [state new-state action]
  (fresh [in out temp]
    (membero in state)
    (ploto in out)
    (rembero in state temp) ; rembero从当前状态中剔除in
    (conso out temp new-state) ; 新生成out加入状态集
    (== action [in out]) ; 取出in <-> out
  )
)

; 以:motorist起始的推导
(with-db story-db
  (run* [q]
    (fresh [action state]
      (== q [action state])
      (actiono [:motorist] state action)
    )
  )
) ; => ([[:motorist :policeman] (:policeman)] [[:motorist :dead-motorist] (:dead-motorist)])

; 反向推导该故事
(declare story*)

(defn storyo* [start-state end-elems actions]
  (fresh [action new-state new-actions]
    (actiono start-state new-state action) ; 动作产生新状态
    (conso action new-actions actions) ; 记录剧情推进
    (conda
      [(everyg #(membero % new-state) end-elems) (== new-actions [])] ; 要求全体元素都满足条件
      [(storyo* new-state end-elems new-actions)]
    )
  )
)

(defn storyo [end-elems actions]
  (storyo* (shuffle start-state) end-elems actions)
)

(with-db story-db
  (run 5 [q] ; 推进5步
    (storyo [:dead-wadsworth] q)
  )
) ; => (([:wadsworth :dead-wadsworth]) ([:maybe-telegram-girl :telegram-girl] [:wadsworth :dead-wadsworth]) ([:maybe-telegram-girl :telegram-girl] [:telegram-girl :dead-telegram-girl] [:dead-telegram-girl :guilty-scarlet] [:wadsworth :dead-wadsworth]) ([:maybe-motorist :motorist] [:wadsworth :dead-wadsworth]) ([:maybe-motorist :motorist] [:motorist :policeman] [:wadsworth :dead-wadsworth]))

; 生成每个动作和对应描述的散列表
(def story-map
  (reduce
    (fn [m elems]
      (assoc m (vec (take 2 elems)) (nth elems 2))
    )
    {}
    story-elements
  )
)

; 打印动作生成描述
(defn print-story [actions]
  (println "PLOT SUMMARY:")
  (doseq [a actions]
    (println (story-map a))
  )
)

(def stories
  (with-db story-db
    (run* [q]
      (storyo [:guilty-scarlet] q)
    )
  )
)
(print-story (first (drop 10 stories))) ; 选取10个之后的故事

(defn story-stream [& goals]
  (with-db story-db
    (run* [q]
      (storyo (vec goals) q)
    )
  )
)
(print-story 
  (first
    (filter 
      #(> (count %) 10) ; 故事的长度在10以上
      (story-stream :guilty-peacock :dead-yvette) ; 指定了故事发展的目标
    )
  )
)

; ※ 这个故事的事实存在一定的缺陷, 因为输入永远会被消费掉, 可以改进它使其具备多个输出
