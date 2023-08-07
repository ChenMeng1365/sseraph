module Colorful   
  attr_accessor :color  
end  

class Widget   
end  

w = Widget.new 
#w.color = 'blue' rescue puts 'w has no color'  

w.extend Colorful # 现在w有color方法了   
w.color = 'blue'  
puts w.color

# 装饰器就是为原本没有某些方法的类实例添加额外的方法

# 扩展方法是实例名后调用extend接模块名

