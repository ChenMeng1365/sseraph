#coding:utf-8

# 1.2
def 斐波那契数列 项数
  raise "项数(#{项数})不能为负数" if 项数<0
  [0,1].include?(项数) ? 1 : (斐波那契数列(项数-1) + 斐波那契数列(项数-2))
end

def 几何级数列 项数
  项数**项数
end

class Fixnum
  def 质数?
    require 'mathn'
    (2..Math.sqrt(self).to_i).collect{|i|self%i!=0}.inject(true){|tof,chk|tof && chk}
  end
end

def 质数积数列 项数
  数列,数组,数集 = [],[],2
  while 数组.size<项数+1
    数组 << 数集 if 数集.质数?
    数集 += 1
  end
  数组[0..-2].each_with_index{|x,i|数列 << x*数组[i+1]}
  return 数列
end

def 圆周率数列 精度=10000
  require 'mathn'
  圆周率 = Math::PI
  # 圆周率 = 4*(0..精度).collect{|i|(-1)**i/(2*i+1)}.inject(0,&:+) # 土法子: 4 * (1 – 1/3 + 1/5 – 1/7 + …)
  圆周率.to_s.gsub('.','').split('').collect{|c|c.to_i}
end

p 斐波那契数列 10
p 几何级数列 17
p 质数积数列(15)
p 圆周率数列.collect{|c|c*2}

# 1.3
def 最后的数列 组项
  数列,表示 = [],[]
  (1..组项).each do|总数|
    (0..总数).each do|后项|
      前项 = 总数 - 后项
      数列 << (2**前项)*(3**后项)
      表示 << "(2**#{前项})*(3**#{后项})"
    end
  end
  return 数列,表示
end

数列,表示 = 最后的数列 10
数列.zip(表示){|num,exp|puts "#{"%8d"%num} #{"%15s"%exp}"}
