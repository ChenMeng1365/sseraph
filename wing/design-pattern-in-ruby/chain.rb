class Chain   
  def initialize   
    @chain = []   
  end  
  
  def add_handler &block   
    @chain << block   
  end  
  
  def handle req   
    @chain.each do |e|   
      # 如果handler返回 false(未处理)，则让下一个处理   
      result = e[req]      
      return result if result   
    end  
    false  
  end   
end  

c = Chain.new  
c.add_handler {|req| req == 1 ? "1:handled" : (puts "1:not my responsibility") }   
c.add_handler {|req| req == 2 ? "2:handled" : (puts "2:not my responsibility") }   
puts (c.handle 1)   
puts (c.handle 2)  
