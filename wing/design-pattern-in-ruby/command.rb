class Command   
  def initialize   
    @executors = []   
  end  
  
  # 另一种方法是让 executors 保存一组对象，每个都带 execute 方法   
  # ——但是这么简单的事情就需要一组接口，一组实现？   
  def add_executor &block   
    @executors << block   
  end  

  def execute   
    @executors.each {|x| x.call }   
  end  
end  

c = Command.new  
c.add_executor{ puts 'executor 1' }   
c.add_executor{ puts 'executor 2' }   

c.execute 

# 以区块作参数传入，传入一个执行过程，再去执行那个过程
# 命令模式就是传入一个执行过程的方法