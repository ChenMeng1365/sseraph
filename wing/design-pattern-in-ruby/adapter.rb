
class Adaptee   
  def talk; puts 'Adaptee';end  
end  

class Adapter < Adaptee   
  alias talkee talk   
  def talk   
    puts 'before Adaptee'  
    talkee   
    puts 'after Adaptee'  
  end  
end  

Adapter.new.talk  

# 适配器就是个换名再包装的过程