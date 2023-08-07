#coding:utf-8
# Object forward := method( (call message name) print )

# 我 := Object clone
# 我 不知道 要 干什么 .

# cat test.io
去向 := method("", (call message argAt(0) ) print; " >=> \"" print; (call message argAt(1) ) print; "\"" println)
来自 := method("", (call message argAt(0) ) print; " <=< \"" print; (call message argAt(1) ) print; "\"" println)
OperatorTable addAssignOperator(">=>", "去向")
OperatorTable addAssignOperator("<=<", "来自")
#doRelativeFile("describe.io")

# cat describe.io
a := "a"
b := "b"
c := "c"
d := "d"

a ">=>" b
c "<=<" d
