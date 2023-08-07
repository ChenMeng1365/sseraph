# 穷举法检验 de Morgan 定理   
class Fixnum  
  %w[a1 a2 a3 b1 b2 b3].each_with_index do |name, idx|   
    define_method name do  
      self & (1<<idx) == 0 ? false : true  
    end  
  end  
end  

0b111111.times.each do |n|   
  n.instance_eval %q[   
      puts 'blah' if (!((a1&&b1) || (a2&&b2) || (a3&&b3)) != !(a1&&b1) && !(a2&&b2) && !(a3&&b3) )
  ]   
end  

