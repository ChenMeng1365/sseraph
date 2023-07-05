
# Metasploit

1.查看系统版本

```shell
cat /etc/redhat-release
```

2.查看系统字体

```shell
fc-list :lang=zh
```

3.进入python，查看matplotlib的设置文件位置

```shell
python
>>> import matplotlib
>>> print(matplotlib.matplotlib_fname())
/home/hadoop/.pyenv/versions/2.7.10/lib/python2.7/site-packages/matplotlib/mpl-data/matplotlibrc
```

4.准备好需要的字体文件(.ttf)
根据上述位置，在`/home/hadoop/.pyenv/versions/2.7.10/lib/python2.7/site-packages/matplotlib/mpl-data/fonts/ttf`中添加缺失字体文件

5.对`/home/hadoop/.pyenv/versions/2.7.10/lib/python2.7/site-packages/matplotlib/mpl-data/matplotlibrc`编辑

```shell
font.family         : sans-serif # 去除注释符
font.sans-serif     : SimHei, Bitstream Vera Sans, Lucida Grande, Verdana, Geneva, Lucid, Arial, Helvetica, Avant Garde, sans-serif # 去除注释符，增加所需字体的名称，这里是SimHei
```

6.删除`~/.cache/matplotlib`缓冲

7.在代码中指定对应字体

```shell
matplotlib.rcParams['font.family']='sans-serif'
matplotlib.rcParams['font.sans-serif'] = ['SimHei']
```

※另一种字体配置方法(未验证)

```shell
from matplotlib.font_manager import *  
myfont = FontProperties(fname='/usr/share/fonts/wqy-zenhei/wqy-zenhei.ttc')  
```
