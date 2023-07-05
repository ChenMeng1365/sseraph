#coding: utf-8

'''
命名：
拉格朗日插值法是以法国十八世纪数学家约瑟夫·路易斯·拉格朗日命名的一种多项式插值方法。

场景：
许多实际问题中都用函数来表示某种内在联系或规律，而不少函数都只能通过实验和观测来了解。
如对实践中的某个物理量进行观测，在若干个不同的地方得到相应的观测值，
拉格朗日插值法可以找到一个多项式，其恰好在各个观测的点取到观测到的值。
这样的多项式称为拉格朗日（插值）多项式。
拉格朗日插值法可以给出一个恰好穿过二维平面上若干个已知点的多项式函数。

参考文献：
https://www.cnblogs.com/zhangte/p/6070127.html

解释：
1. 已有的数据样本被称之为 “插值节点”
2. 对于特定插值节点，它所对应的插值函数是必定存在且唯一的。
   也就是说对于同样的插值样本来说，用不同方法求得的插值函数本质上其实是一样的。
3. 拉格朗日插值法依赖于每个插值节点对应的插值基函数，也就是说每个插值节点都有对应的插值基函数。
4. 拉格朗日插值函数最终由所有插值节点中每个插值节点的纵坐标值与它对应的插值函数的积的和构成。
5. 也就是说拉格朗日插值法关键在于求基函数。
6. 拉格朗日插值法并不好，当每一次加入新的插值节点的时候，所有的系数都要重算一遍。
'''

"""
@brief: 获取各节点的基函数
@param: xi    某个节点的坐标值
@param: x_set 样本中所有节点的坐标值
@return: 某个节点的基函数
"""
def get_li(xi, x_set = []):
  def li(Lx):
    W = 1; c = 1
    for each_x in x_set:
      if each_x == xi:
        continue
      W = W * (Lx - each_x)
    for each_x in x_set:
      if each_x == xi:
        continue
      c = c * (xi - each_x)
    return W / float(c) # 确保转成float型
  return li


"""
@brief: 获得拉格朗日插值函数
@param: x       插值节点的横坐标集合
@param: fx      插值节点的纵坐标集合 
@return: 参数所指定的插值节点集合对应的插值函数
"""   
def get_Lxfunc(x = [], fx = []):
  set_of_lifunc = []
  for each in x:  # 获得每个插值点的基函数
    lifunc = get_li(each, x)
    set_of_lifunc.append(lifunc)    # 将集合x中的每个元素对应的插值基函数保存

  def Lxfunc(Lx):
    result = 0
    for index in range(len(x)):
      result = result + fx[index]*set_of_lifunc[index](Lx)    # 根据拉格朗日插值法计算Lx的值
    return result

  return Lxfunc


if __name__ == '__main__':  
  import matplotlib.pyplot as plt
  ''' 插值 '''
  sr_x = [i for i in range(-50, 50, 10)]  # 每两个节点x轴距离位10
  sr_fx = [i**2 for i in sr_x]            # 用二次函数生成插值节点
  Lx = get_Lxfunc(sr_x, sr_fx)            # 获得插值函数
  tmp_x = [i for i in range(-145, -51) ]  # 测试用例
  tmp_y = [Lx(i) for i in tmp_x]          # 根据插值函数获得测试用例的纵坐标

  from scipy.interpolate  import lagrange
  tmp_z = [lagrange(sr_x,sr_fx)(i) for i in tmp_x] # 直接调用scipy库

  ''' 画图 '''
  plt.figure("play")

  ax1 = plt.subplot(211) # 纵图数:横图数:编号
  plt.sca(ax1)
  plt.plot(sr_x, sr_fx, linestyle = ' ', marker='o', color='r')
  plt.plot(tmp_x, tmp_y, linestyle = "-", color='g')

  ax2 = plt.subplot(212)
  plt.sca(ax2)
  plt.plot(sr_x, sr_fx, linestyle = ' ', marker='o', color='r')
  plt.plot(tmp_x, tmp_z, linestyle = '--', color='b')

  plt.show()