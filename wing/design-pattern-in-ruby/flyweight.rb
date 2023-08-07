class FlyweightFactory   
  class Glyph   
    def initialize key   
      @key = key   
      sleep 1 # 睡一秒，以体现这个对象创建的“重量级”   
      @square = key ** 2   
      @cubic = key ** 3   
    end  
    attr_reader :key, :square, :cubic  
  end  
    
  def produce key   
    @glyphs ||= {}   
	  @glyphs[key] || (@glyphs[key] = Glyph.new key)   
	end  
end  
  
ff = FlyweightFactory.new  
g1 = ff.produce 2   
g2 = ff.produce 2   
puts (g1.object_id == g2.object_id) 

# 使用了||=，非空元素不进行处理
# 轻量方法就是对相同参数的实例不再重复生成
