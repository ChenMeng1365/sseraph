#coding:utf-8
require 'mathn'

def random n
	(rand)/32768*n + 0.5
end

# 快速乘法取模
def q_mul a, b, mod 
	ans = 0
	while b!=0
		ans += a if (("%0b"%b)[-1].to_i & 1) != 0
		b = (b / 2).to_i
		a = ( a + a ) % mod
	end
	return ans
end

# 快速乘法下的快速幂
def q_pow a, b, mod
  ans = 1
  while b!=0
    ans = q_mul(ans, a, mod) if (("%0b"%b)[-1].to_i & 1)!=0
    b = (b / 2).to_i
    a = q_mul( a, a, mod )
  end
  return ans
end

# miller_rabin算法的精华
def witness a, n
  tem = n - 1
  j = 0
  while (tem%2==0)
    tem = (tem / 2).to_i
    j = j + 1
  end
  x = q_pow( a, tem, n ) # a^(n-1) mod n
  return true if (x==1 || x==(n-1))
  while j!=0
    x = q_mul(x, x, n)
    return true if x==( n - 1 )
    j = j - 1
  end
  return false
end

# 检验n是否是素数
def miller_rabin n
  return true if n==2
  return false if (n<2 || (n%2==0))
  50.times.each do|i| # 做times次随机检验
    a = random( n - 2 ) + 1 # 得到随机检验算子 a
    return false if !witness(a, n) # 用a检验n是否是素数
  end
  return true
end

def gcd a, b
  return a if b == 0
  return gcd( b, a%b )
end

# 找到n的一个因子
def pollard_rho n, c
  i,k = 1,2
  x = random(n-1) + 1
  y = x
  while true
    i = i + 1
    x = (q_mul( x, x, n ) + c) % n
    d = gcd( y - x, n )
    return d if (1 < d && d < n)
    return n if(y == x) # 找到循环，选取失败，重新来
    (y = x;k << 1) if(i == k)
  end
end

def find n, c, maps, number
  return 0 if n==1
  if miller_rabin(n)
    maps[n] = maps[n]+1
    number = number + 1
    return 0
  end
  p = n
  while p >= n
    p = pollard_rho(p, c )
    c = c - 1
    find( p, c, maps, number )
    find( (n / p), c, maps, number )
  end
end

=begin
  tar = 84501766124061696355126082876615736050316124451023361713885139637491778482833
  number = 0
  maps = {}
  find( tar, 2137342, maps, number )
  maps.each do|long,short|
    puts "#{long} #{short} * "
  end
=end
