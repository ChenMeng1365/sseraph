# 工头   
class Director   
  def build_with builder   
    acc = ''  
    [:header, :body, :footer].each do |m|   
      acc += builder.__send__ m if builder.respond_to? m   
    end  
    acc   
  end  
end  

# 工人   
class HTMLBuilder   
  def header; '<html><title>html builder</title>';end  
  def body;   '<body>html builder</body>'        ;end  
  def footer; '</html>'                          ;end  
end  
class XMLBuilder   
  def header; '<?xml version="1.0" charset="utf-8">';end  
  def body;   '<root>xml builder</root>'            ;end  
end  

d = Director.new  
puts (d.build_with HTMLBuilder.new)   
puts (d.build_with XMLBuilder.new)  

# __send__将方法当做消息参数传给该对象使其自行调用
# respond_to?检查该对象是否包含某个方法

# 一个主加工流程类，若干个不同的具体加工方法类
# 对主加工流程类的实例，传入不同的具体加工方法类的实例来指导具体产品的生成

