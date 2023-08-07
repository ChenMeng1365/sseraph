class Factory   
  attr_accessor :product  
  def produce   
    @product.new  
  end  
end  

class Product   
  #..   
end  

fac = Factory.new  
fac.product = Product   
fac.produce  

# 工厂类有一个方法生成产品类实例
# 生成工厂类实例，调用该方法生成产品类实例