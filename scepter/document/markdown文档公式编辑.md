
# LaTex in Markdown

单行公式放在一对`$`中(左对齐)，多行Tex放在一对`$$`中(居中)。

特殊字符直接输出需在符号前加一个转义字符`\`。

## 说明

[常用数学符号的LaTeX表示方法](http://www.mohu.org/info/symbols/symbols.htm)

|类别        |字体命令         |输出效果                           |
|------------|----------------|----------------------------------|
|默认字体    |`$\mathnormal{}$`|A B C e f g 123 ABCefg123ABCefg123|
|意大利体    |`$\mathit{}$`    |$ \mathit{ABCefg123} $            |
|罗马体      |`$\mathrm{}$`    |$ \mathrm{ABCefg123} $            |
|粗体        |`$\mathbf{}$`    |$ \mathbf{ABCefg123} $            |
|无衬线体    |`$\mathsf{}$`    |$ \mathsf{ABCefg123} $            |
|打字机体    |`$\mathtt{}$`    |$ \mathtt{ABCefg123} $            |
|手写体(花体)|`$\mathcal{}$`   |$ \mathcal{ABCefg123} $           |

|希腊字母|字母命令|希腊字母|字母命令|
|---|---|---|---|
|$\alpha$|`$\alpha$`|$\Alpha$|`$\Alpha$`|
|$\beta$|`$\beta$`|$\Beta$|`$\Beta$`|
|$\gamma$|`$\gamma$`|$\Gamma$|`$\Gamma$`|
|$\delta$|`$\delta$`|$\Delta$|`$\Delta$`|
|$\epsilon$|`$\epsilon$`|$\Epsilon$|`$\Epsilon$`|
|$\zeta$|`$\zeta$`|$\Zeta$|`$\Zeta$`|
|$\eta$|`$\eta$`|$\Eta$|`$\Eta$`|
|$\theta$|`$\theta$`|$\Theta$|`$\Theta$`|
|$\iota$|`$\iota$`|$\Iota$|`$\Iota$`|
|$\kappa$|`$\kappa$`|$\Kappa$|`$\Kappa$`|
|$\lambda$|`$\lambda$`|$\Lambda$|`$\Lambda$`|
|$\mu$|`$\mu$`|$\Mu$|`$\Mu$`|
|$\nu$|`$\nu$`|$\Nu$|`$\Nu$`|
|$\xi$|`$\xi$`|$\Xi$|`$\Xi$`|
|$o$|`$o$`|$O$|`$O$`|
|$\pi$|`$\pi$`|$\Pi$|`$\Pi$`|
|$\rho$|`$\rho$`|$\Rho$|`$\Rho$`|
|$\sigma$|`$\sigma$`|$\Sigma$|`$\Sigma$`|
|$\tau$|`$\tau$`|$\Tau$|`$\Tau$`|
|$\upsilon$|`$\upsilon$`|$\Upsilon$|`$\Upsilon$`|
|$\phi$|`$\phi$`|$\Phi$|`$\Phi$`|
|$\chi$|`$\chi$`|$\Chi$|`$\Chi$`|
|$\psi$|`$\psi$`|$\Psi$|`$\Psi$`|
|$\omega$|`$\omega$`|$\Omega$|`$\Omega$`|

|符号含义|写法|样式|
|---|---|---|
|上标|`^`|$a^b$|
|下标|`_`|$x_{2}$|
|分数|`\frac`|$\frac{a}{b}$|
|分数|`\dfrac`|$\dfrac{a}{b}$|
|分数|`\tfrac`|$\tfrac{a}{b}$|
|空格|`\quad`|${a}\quad{b}$|
|双空格|`\qquad`|${a}\qquad{b}$|
|1/3空格|`\:`|${a}\:{b}$|
|2/7空格|`\;`|${a}\;{b}$|
|1/6空格|`\,`|${a}\,{b}$|
|缩进1/6空格|`\!`|${a}\!{b}$|
|正负|`\pm`|$\pm$|
|乘|`\times`|$\times$|
|除|`\div`|$\div$|
|下标省略号|`\dots`|$\dots$|
|中心省略号|`\cdots`|$\cdots$|
|垂直省略号|`\vdots`|$\vdots$|
|斜省略号|`\ddots`|$\ddots$|
|单点|`\cdot`|$\cdot$|
|交|`\cap`|$\cap$|
|并|`\cup`|$\cup$|
|大于等于|`\geq`|$\geq$|
|小于等于|`\leq`|$\leq$|
|不等于|`\neq`|$\neq$|
|约等于|`\approx`|$\approx$|
|精确等于|`\equiv`|$\equiv$|
|求和|`\sum`|$\sum$|
|求积|`\prod`|$\prod$|
|极限|`\lim`|$\lim$|
|积分|`\int`|$\int$|
|二重积分|`\iint`|$\iint$|
|三重积分|`\iiint`|$\iiint$|
|左箭头|`\leftarrow`|$\leftarrow$|
|右箭头|`\rightarrow`|$\rightarrow$|
|上箭头|`\uparrow`|$\uparrow$|
|下箭头|`\downarrow`|$\downarrow$|
|左右箭头|`\leftrightarrow`|$\leftrightarrow$|
|长左箭头|`\longleftarrow`|$\longleftarrow$|
|长左粗箭头|`\Longleftarrow`|$\Longleftarrow $|
|文字左箭头|`\xleftarrow[a]{x+y+z}`|$\xleftarrow[a]{x+y+z}$|
|上划线|`\overline`|$\overline{xxx}$|
|下划线|`\underline`|$\underline{xxx}$|
|上左箭头|`\overleftarrow`|$\overleftarrow{xxx}$|
|下左箭头|`\underleftarrow`|$\underleftarrow{xxx}$|
|上左右箭头|`\overleftrightarrow`|$\overleftrightarrow{xxx}$|
|下左右箭头|`\underleftrightarrow`|$\underleftrightarrow{xxx}$|
|阴平|`\bar`|$\bar{x}$|
|阳平|`\acute`|$\acute{x}$|
|上声|`\check`|$\check{x}$|
|去声|`\grave`|$\grave{x}$|
|向量|`\vec`|$\vec{x}$|
|样本值|`\dot`|$\dot{x}$|
||`\mathring`|$\mathring{x}$|
|样本集|`\hat`|$\hat{x}$|
||`\tilde`|$\tilde{x}$|
||`\ddot`|$\ddot{x}$|
||`\breve`|$\breve{x}$|
||`\widehat`|$\widehat{xxx}$|
||`\widetilde`|$\widetilde{xxx}$|
||`\overbrace`|$\overbrace{xxx}$|
||`\underbrace`|$\underbrace{xxx}$|

---

## 实例

0. 粗体、斜体、加框

```tex
$ f(x) = \textbf{x}^2 $
```

$ f(x) = \textbf{x}^2 $

```tex
$ f(x) = x^2 \mbox{\emph{abcd} defg} $
```

$ f(x) = x^2 { { abcd } defg } $
$ f(x) = x^2 {  abcd  defg } $

```tex
$ f(x) = \boxed{\textbf{x}^2} $
```

$ f(x) = \boxed{\textbf{x}^2} $

1. 上下标

```tex
$ f(x) = x^ 2 $
```

$ f(x) = x^ 2 $

或者

```tex
$ f(x) = {x}^ {2} $
```

$ f(x) = {x}^ {2} $

```tex
$ f(x) = x_2 $
```

$ f(x) = x_2 $

或者

```tex
$ f(x) = {x}_{2} $
```

$ f(x) = {x}_{2} $

```tex
$ f(x) = x_1^2 + {x}_{2}^{2} $
```

$ f(x) = x_1^2 + {x}_{2}^{2} $

2. 分数

```tex
$ f(x,y) = \frac{x^2}{y^3} $
```

$ f(x,y) = \frac{x^2}{y^3} $

3. 开方

```tex
$ f(x,y) = \sqrt[n]{{x^2}{y^3}} $
```

$ f(x,y) = \sqrt[n]{{x^2}{y^3}} $

4. 省略

```tex
$ f(x_1, x_2, \ldots, x_n) = x_1 + x_2 + \cdots + x_n $
```

$ f(x_1, x_2, \ldots, x_n) = x_1 + x_2 + \cdots + x_n $

5. 高括号

```tex
$ {f}'(x) = \left( \frac{df}{dx} \right) $
```

$ {f}'(x) = \left( \frac{df}{dx} \right) $

方括号[]、大括号{}类似。

```
$ {f}'(0) =  \left. \frac{df}{dx} \right|_{x=0} $
```

$ {f}'(0) =  \left. \frac{df}{dx} \right|_{x=0} $

6. 矩阵、行列式

```tex
$ A=\left[ \begin{matrix}
   a & b  \\
   c & d  \\
\end{matrix} \right] $
```

$ A=\left[ \begin{matrix}
   a & b  \\
   c & d  \\
\end{matrix} \right] $

```tex
$ \chi (\lambda)=\left| \begin{matrix}
   \lambda - a & -b  \\
   -c & \lambda - d  \\
\end{matrix} \right| $
```

$ \chi (\lambda)=\left| \begin{matrix}
   \lambda - a & -b  \\
   -c & \lambda - d  \\
\end{matrix} \right| $

```tex
$ \begin{array}{ccc}
x_1 & x_2 &\dots\\
x_3 & x_4 &\dots\\
\vdots&\vdots&\ddots
\end{array} $
```

$ \begin{array}{ccc}
x_1 & x_2 &\dots\\
x_3 & x_4 &\dots\\
\vdots&\vdots&\ddots
\end{array} $

```tex
$ \begin{pmatrix}
a & b\\
c & d \\
\end{pmatrix}
\quad
\begin{bmatrix}
a & b \\
c & d \\
\end{bmatrix}
\quad
\begin{Bmatrix}
a & b \\
c & d \\
\end{Bmatrix}
\quad
\begin{vmatrix}
a & b \\
c & d \\
\end{vmatrix}
\quad
\begin{Vmatrix}
a & b \\
c & d \\
\end{Vmatrix}
\quad
(
\begin{smallmatrix}
a & b \\
c & d
\end{smallmatrix}
) $
```

$ \begin{pmatrix}
a & b\\
c & d \\
\end{pmatrix}
\quad
\begin{bmatrix}
a & b \\
c & d \\
\end{bmatrix}
\quad
\begin{Bmatrix}
a & b \\
c & d \\
\end{Bmatrix}
\quad
\begin{vmatrix}
a & b \\
c & d \\
\end{vmatrix}
\quad
\begin{Vmatrix}
a & b \\
c & d \\
\end{Vmatrix}
\quad
(
\begin{smallmatrix}
a & b \\
c & d
\end{smallmatrix}
) $

7. 等式、分支

等式排版只能在显示模式下设置(`$$`)

无需对齐使用multline；需要对齐使用split；用\\来分行；用&设置对齐的位置。

```tex
$$ \begin{multline} x = a+b+c+{}\\ d+e+f+g \end{multline} $$
```

$$ \begin{multline} x = a+b+c+{}\\ d+e+f+g \end{multline} $$

```tex
$$ \begin{split} x = {} & a + b + c +{}\\ & d + e + f + g \end{split} $$
```

$$ \begin{split} x = {} & a + b + c +{}\\ & d + e + f + g \end{split} $$

不需要对齐的公式组用gather；需要对齐使用align。

```tex
$$ \begin{gather} a = b+c+d\\ x = y+z\\ 5 = 4+1\\ \end{gather} $$
```

$$ \begin{gather} a = b+c+d\\ x = y+z\\ 5 = 4+1\\ \end{gather} $$

```tex
$$ \begin{align} a &=b+c+d \\ x &=y+z\\ 5 &= 4+1 \end{align} $$
```

$$ \begin{align} a &=b+c+d \\ x &=y+z\\ 5 &= 4+1 \end{align} $$

```tex
$ y=\begin{cases} -x,\quad x\leq 0\\ x, \quad x>0 \end{cases} $
```

$ y=\begin{cases} -x,\quad x\leq 0\\ x, \quad x>0 \end{cases} $

8. 求和、积

```tex
$ \sum_{k=1}^n k^2 = \frac{1}{2} n (n+1) $
```

$ \sum_{k=1}^n k^2 = \frac{1}{2} n (n+1) $

9. 导数

```tex
$ {f}'(x) = x^2 + x $
```

$ {f}'(x) = x^2 + x $

10. 极限

```tex
$ \lim_{x \to 0} \frac{3x^2 +7x^3}{x^2 +5x^4} = 3 $
```

$ \lim_{x \to 0} \frac{3x^2 +7x^3}{x^2 +5x^4} = 3 $

11. 积分

```tex
$ \int_a^b f(x)\,dx $
```

$ \int_a^b f(x)\,dx $

```tex
$ \int_0^{+\infty} x^n e^{-x} \,dx = n! $
```

$ \int_0^{+\infty} x^n e^{-x} \,dx = n! $

```tex
$ \int_{x^2 + y^2 \leq R^2} f(x,y)\,dx\,dy = 
\int_{\theta=0}^{2\pi} \int_{r=0}^R 
f(r\cos\theta,r\sin\theta) r\,dr\,d\theta $
```

$ \int_{x^2 + y^2 \leq R^2} f(x,y)\,dx\,dy = 
\int_{\theta=0}^{2\pi} \int_{r=0}^R 
f(r\cos\theta,r\sin\theta) r\,dr\,d\theta $

```tex
$ \int \!\!\! \int_D f(x,y)\,dx\,dy
\int \int_D f(x,y)\,dx\,dy $
```

$ \int \!\!\! \int_D f(x,y)\,dx\,dy
\int \int_D f(x,y)\,dx\,dy $

在多重积分内的dx和dy之间使用`\,`来增大稍许间距，在两个积分号之间使用`\!`来减小稍许间距，使之更美观。

```tex
$ i\hbar\frac{\partial \psi}{\partial {t}} = \frac{-\hbar^2}{2m} 
\left( \frac{\partial^2}{\partial x^2} + \frac{\partial^2}{\partial y^2} + 
\frac{\partial^2}{\partial z^2} \right) \psi + V \psi $
```

$ i\hbar\frac{\partial \psi}{\partial {t}} = \frac{-\hbar^2}{2m} 
\left( \frac{\partial^2}{\partial x^2} + \frac{\partial^2}{\partial y^2} + 
\frac{\partial^2}{\partial z^2} \right) \psi + V \psi $

```tex
$ \frac{d}{dt} \int \!\!\! \int \!\!\! \int_{\textbf{R}^3} \left
| \psi(\mathbf{r},t) \right|^2\,dx\,dy\,dz = 0 $
```

$ \frac{d}{dt} \int \!\!\! \int \!\!\! \int_{\textbf{R}^3} \left
| \psi(\mathbf{r},t) \right|^2\,dx\,dy\,dz = 0 $

12. 多重括号

```tex
$
\Bigg( \bigg( \Big( \big((x) \big) \Big) \bigg) \Bigg)
\quad
\Bigg[ \bigg[ \Big[ \big[[x] \big] \Big] \bigg] \Bigg]
\quad
\Bigg\{ \bigg\{ \Big\{ \big\{\{x\} \big\} \Big\} \bigg\} \Bigg\}
$
```

$
\Bigg( \bigg( \Big( \big((x) \big) \Big) \bigg) \Bigg)
\quad
\Bigg[ \bigg[ \Big[ \big[[x] \big] \Big] \bigg] \Bigg]
\quad
\Bigg\{ \bigg\{ \Big\{ \big\{\{x\} \big\} \Big\} \bigg\} \Bigg\}
$

```tex
$
\Bigg\langle \bigg\langle \Big\langle \big\langle\langle x \rangle \big\rangle \Big\rangle \bigg\rangle \Bigg\rangle
\quad
\Bigg\lvert \bigg\lvert \Big\lvert \big\lvert\lvert x \rvert \big\rvert \Big\rvert \bigg\rvert \Bigg\rvert
\quad
\Bigg\lVert \big \lVert \Big\lVert \big\lVert \lVert x \rVert \big\rVert \Big\rVert \bigg\rVert \Bigg\rVert
$
```

$
\Bigg\langle \bigg\langle \Big\langle \big\langle\langle x \rangle \big\rangle \Big\rangle \bigg\rangle \Bigg\rangle
\quad
\Bigg\lvert \bigg\lvert \Big\lvert \big\lvert\lvert x \rvert \big\rvert \Big\rvert \bigg\rvert \Bigg\rvert
\quad
\Bigg\lVert \big \lVert \Big\lVert \big\lVert \lVert x \rVert \big\rVert \Big\rVert \bigg\rVert \Bigg\rVert
$


