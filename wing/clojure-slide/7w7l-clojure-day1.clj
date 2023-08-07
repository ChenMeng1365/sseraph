
;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 前缀表示法
; 空格分隔
(+ 1 2 3.0)
(mod 5 4)
(< 1 3 2 4)

; 类型系统(兼容java)
(class (/ 1 2))

; 字符, 字符串, 关键字, 标号
(str "a: " 1 ", b: " 2)
(str \f \o \r \c \e)
(class \a)
(class 'a')
(class :a)
(class "a")
(= "a" \a)
(= 'a' 'a) ; => false

; ※ 关键字指向自身, 标号指向其他
(class :true) ; 关键字是函数
(class true) ; true只是个标号
(= true :true) ; => false
(= true 'true) ; => true

; (if cond do-something *else-do-others)
(if (< 1 2) (println :one_letter_than_two) (println "this case will not be executed."))

; nil =/= () ; nil =/= false ; 二者的分支压根不会执行
(if () (println "empty list")) ; => "empty list"
(if nil (println "atom nil")) ; => nil
(if false (println "atom false")) ; => nil

;;; 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; list constructors:
(=
  (list 1 2 "3")
  '(1 2 "3")
)

; list operators:
(first '(1 2 3))
(last '(1 2 3))
(rest '(1 2 3))
(cons 0 '(1 2 3))

; vector constructor:
[1 2 3]

; vector operators:
(first [1 2 3])
(last [1 2 3])
(rest [1 2 3]) ; => (2 3) ; list
(nth [1 2 3] 2) ; 向量也是有序的, 但它具备随机访问特性
([1 2 3] 2) ; []其实是函数, 直接调用就是对向量估值
(concat [0] [1 2 3]) ; => (0 1 2 3) ; list

; set constructor:
#{1 2 3} ; 无序

; set operators:
(count #{1 2 3})
(sort #{2 1 '3}) ; => (1 2 3) ; list
(sorted-set 2 1 '3) ; => #{1 2 3} ; set
(sorted-set #{2 1 '3}) ; => #{#{1 3 2}} ; ???
(clojure.set/union #{0} #{1 2 3})
(clojure.set/difference #{2} #{1 3 2})
(#{1 2 3} 4) ; #{}也是函数, 直接调用就是对集合估值, 可以据此判断一个值是否属于集合

; map constructor:
(=
  {:a 1 :b 2}
  {:a 1, :b 2} ; 逗号只是方便区分kv对
)

; map operators:
({:a 1 :b 2} :a) ; {}也是函数, 直接调用就是对映射表估值
(merge {:a 1 :b 2} {'c 3})
(merge-with + {:a 1 :b 2} {:b 4 'c 3}) ; 相同key的元素进行操作
(assoc {:a 1 :b 2} 'c 3)
(sorted-map :b 2 :c 3 :a 1) ; 构造排序映射表, 但是key要统一类型

;;; 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; function
(defn do-something "description" [parameter] (str parameter))
(do-something 1)
(doc do-something)

(fn [x] (x))
#('function %1 %2)
(map (fn [x y] (- x y)) [1 2 3] [4 5 6])
(map #(- %1 %2) [1 2 3] [4 5 6])

; binding
(def var 1)

; match-pattern
(defn match [[_ another]] another)
(match [1 2 3])
(let [var :a] {:a 1 :b 2 'c 3})
(let [[_ {var :a}] [{:a 1 :b 2 'c 3} {:a 'a :b 'b :c 'c}] ] var)

; iterators
(map list [1 2 3]) ; list本身就是函数
(apply + [1 2 3])
(apply max [1 2 3])
(filter odd? [1 2 3])