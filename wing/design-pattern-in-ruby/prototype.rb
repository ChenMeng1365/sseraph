require 'evil'  

class Prototype   
	  # ...   
end  

class Concrete   
	  include Prototype.as_module   
end  

# 将原型类转换为模块，用于具体类
