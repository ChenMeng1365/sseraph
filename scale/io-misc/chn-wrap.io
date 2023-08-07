#coding:utf-8

对象 := method( Object clone )

# 条件

如果 := method(
  call sender doMessage(call message argAt(0)) \
  ifTrue(call sender doMessage(call message argAt(1))) \
  ifFalse(call sender doMessage(call message argAt(2)))
)

除非 := method(
  call sender doMessage(call message argAt(0)) \
  ifFalse(call sender doMessage(call message argAt(1))) \
  ifTrue(call sender doMessage(call message argAt(2)))
)

# 循环

重复 := method( loop(call sender doMessage(call message argAt(0))) )
循环 := method(
  while(
    call sender doMessage(call message argAt(0)),
    call sender doMessage(call message argAt(1))
  )
)

Number 次循环 := method(
  repeat( call sender doMessage(call message argAt(0)) )
)

累计 := method( arg,
  参数 := List clone
  (call message arguments) foreach( argument, 参数 append(argument) )
  if( 参数 size == 5,
    for(参数 at(0),参数 at(1) asString asNumber,参数 at(2) asString asNumber,参数 at(3) asString asNumber,参数 at(4)),
    for(参数 at(0),参数 at(1) asString asNumber,参数 at(2) asString asNumber,参数 at(3))
  )
)

打印 := method( text,writeln(text) )

Object 打印 := method( self println )




如果( 1 == "1",
  writeln("数字1等于字符1"),
  writeln("数字1不等于字符1")
)

打印("目标文本")
"主体文本" 打印

i := 0
#重复( 打印(i);i = i+1;wait(0.7) )
#循环( i<=10, i 打印;i = i+1 )

#3 次循环(writeln("1"))
累计( i, 1, 10, 打印(i) )


