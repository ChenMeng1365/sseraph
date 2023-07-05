#coding:utf-8
require 'benchmark'

=begin
  Benchmark.bm do|action|  
    action.report("title") do
      # ...
    end
    
    # ... 
  end
=end

# case 1:
Benchmark.bm{|x|
  x.report('+='){
    a = ""
    10000.times{a+="foo"}
  }
  x.report("<<"){
    a = ""
    10000.times{a<<"foo"}
  }
}
# 字符串的<<要优于+=

# case 2:
Benchmark.bm do|x|
  x.report('unshf')do
    a = []
    10000.times{a.unshift"foo"}
  end
  x.report("push")do
    a = []
    10000.times{a.push"foo"}
  end
  x.report("<<")do
    a = []
    10000.times{a<<"foo"}
  end
end
# 数组的<<要优于其他添加方法