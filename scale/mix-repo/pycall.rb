#coding:utf-8

# 在ruby中使用pycall执行python解释器

# [安装]
# gem install pycall --pre
# 或
# Gemfile中gem 'pycall'然后bundle

# [注意]
# pycall.rb 需要Python共享库（libpython3.7m.so）而pyenv默认不构建共享库，因此需要--enable-shared在安装时指定选项
# env PYTHON_CONFIGURE_OPTS='--enable-shared' pyenv install 3.7.2

# 使用PYTHON环境变量来指定解释器路径, 没有指定时默认先取python3, 再取python
# $PYTHON=/usr/local/bin/python3 ruby pycall-example.rb

# 遇到PyCall::PythonNotFound时, 使用PYCALL_DEBUG_FIND_LIBPYTHON环境变量来查看调用栈
# $PYCALL_DEBUG_FIND_LIBPYTHON=1 ruby -rpycall -ePyCall.builtins

# [原理]
# 通过PyCall::PyPtr包装python对象, PyCall::PyPtr有两个子类(PyCall::PyTypePtr, PyCall::PyRubyPtr)
# PyCall::PyTypePtr为类型对象所用, PyCall::PyRubyPtr为ruby对象所用
# 主要使用PyCall::PyObjectWrapper来包装Object, Module和Class, 它mix-in到PyCall::PyPtr中(PyCall::PyPtr必须实现了@__pyptr__实例变量)实现ruby对象到python对象之间的转换


require 'pycall'

# 自动类型转换
# 数值, 字符串, 布尔值, 数组, 散列

# 构造函数
# classname(x, y, z) ==> classname.new(x, y, z)

# 对象运算
# obj(x, y, z) ==> obj.(x, y, z)

# 列表传值
# func(x=1, y=2, z=3) ==> func(x:1, y:2, z:3)

# 不能直接取方法名
# obj.meth ==> PyCall.getattr(obj, :meth)

# 对长时间执行的方法使用PyCall.without_gvl来取消GVL, 不声明则会获取GVL
PyCall.without_gvl do
  pyobj.long_running_function()
end

# example
math = PyCall.import_module("math")
math.sin(math.pi / 4) - Math.sin(Math::PI / 4)   # => 0.0

# 一般对象PyCall.import_module来导入, 但科学计算几个库有专门的gem:

# gem install --pre matplotlib
require 'matplotlib/pyplot'
plt = Matplotlib::Pyplot

xs = [*1..100].map {|x| (x - 50) * Math::PI / 100.0 }
ys = xs.map {|x| Math.sin(x) }

plt.plot(xs, ys)
plt.show()

# gem install numpy
require 'numpy'

x = Numpy.asarray([[1, 2, 3], [4, 5, 6]])
puts x
# [[1 2 3]
#  [4 5 6]]

puts x[1, 1..2]
# [5 6]

puts x.T
# [[1 4]
#  [2 5]
#  [3 6]]

puts x.dot x.T
# [[14 32]
#  [32 77]]

puts x.reshape([3, 2])
# [[1 2]
#  [3 4]
#  [5 6]]

# gem install pandas
require 'pandas'
df = Pandas.read_csv('data/titanic.csv')

puts df.groupby(:Sex)[:Survived].describe
#         count      mean       std  min  25%  50%  75%  max
# Sex
# female  314.0  0.742038  0.438211  0.0  0.0  1.0  1.0  1.0
# male    573.0  0.190227  0.392823  0.0  0.0  0.0  0.0  1.0

puts df.groupby(:Sex)[:Age].describe
#         count       mean        std   min   25%   50%   75%   max
# Sex
# female  314.0  27.719745  13.834740  0.75  18.0  27.0  36.0  63.0
# male    573.0  30.431361  14.197273  0.42  21.0  28.0  38.0  80.0

# 其他机器学习的方法参看
# https://github.com/arbox/machine-learning-with-ruby
