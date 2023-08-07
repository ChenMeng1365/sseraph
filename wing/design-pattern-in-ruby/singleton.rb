module SingletonClass   
  class << self  
    # methods 
    def pil
      puts "我是RN教教徒"
    end
  end  
end  

SingletonClass.pil
