#import "/typ-layout/common.typ": cheatsheet
#import "/typ-layout/math-util.typ": *

#let sinc = math.op("sinc")
#let Sa = math.op("Sa")
#let rect = math.op("rect")
#let pv = math.op("p.v.")
#let sgn = math.op("sgn")
#let erf = math.op("erf")
#let erfc = math.op("erfc")
#let bit = math.op("bit")
#let EX = math.op("E")
#let Pr = math.op("P")

#show: cheatsheet.with(columns: 5, title: "奇襲通原")

#title[奇襲通原☞]

= 基本约定

除非特别说明，下面的叙述全部关于复信号。记号上虚数单位用 $jj$ 表示，用 $(dot)^*$ 表示复共轭，上划线 $overline((dot))$ 表示时间平均。复内积都保持第一个位置线性，第二个位置共轭线性。卷积用 $*$ 表示。傅里叶变换采用模拟频率 $f$ 的形式，用 $cal(F)[dot]$ 表示，变换对用 $<=>$ 表示。柯西主值用 $pv$ 表示。对随机变量的积分和极限都是均方意义下的。$log$ 表示以 $2$ 为底的对数。分析数字通信时默认按符号等概率计算。

== 常用函数性质

单位冲激信号$(f * delta)(t) = f(t)$

阶跃函数 $u(t) = (hfrac(1, 2)) (1 + sgn(t))$

采样函数 $Sa(t) = hfrac((sin t), t)$ , $Sa(0)=1$

$sinc$ 脉冲 $sinc(t) = Sa(pi t)$

单位矩形脉冲 $rect(t) = u(t + (hfrac(1, 2))) - u(t - (hfrac(1, 2)))$

$n$ 阶Bessel函数

$ J_n (beta) = 1 / (2 pi) integral_(-pi)^pi ee^(jj (beta sin theta - n theta)) dd(theta) $

误差函数

$ erf(x) = 2 / sqrt(pi) integral_0^x ee^(-t^2) dd(t) $

互补误差函数 $erfc(x)=1- erf(x)$

= 通信系统模型

#strong[信源] #sym.arrow [信源编码 #sym.arrow 信道编码] #sym.arrow #strong[信道] #sym.arrow [信道译码 #sym.arrow 信源译码] #sym.arrow #strong[信宿]

= 确定信号分析

== 基本概念

信号 $x(t)$ 的时间平均

$ overline(x(t)) = lim_(T -> oo) 1 / T integral_(-hfrac(T, 2))^(+hfrac(T, 2)) x(t) dd(t) $

能量

$ E_x = integral_(-oo)^(+oo) abs(x(t))^2 dd(t) $

功率

$ P_x = overline(abs(x(t))^2) $

能量信号 $x(t)$ , $y(t)$ 的内积（互能量）

$ E_(x y) = integral_(-oo)^(+oo) x(t) y^*(t) dd(t) $

功率信号 $x(t)$ , $y(t)$ 的内积（互功率）

$ P_(x y) = overline(x(t) y^*(t)) $

Cauchy-Schwarz 不等式

$ chevron.l x, y chevron.r <= sqrt(norm(x)^2 norm(y)^2) $

== 频谱

周期为 $T$ 的信号 $x(t)$ 的傅里叶级数

$
  x(t) = sum_(n = -oo)^(+oo) x_n ee^(jj 2 pi n f t), quad f = 1 / T \
  x_n = 1 / T integral_(-hfrac(T, 2))^(+hfrac(T, 2)) x(t) ee^(-jj 2 pi n f t) dd(t) \
$

能量信号 $x(t)$ 的傅里叶变换

$ X(f) = integral_(-oo)^(+oo) x(t) ee^(-jj 2 pi f t) dd(t) $

$X(f)$ 的逆傅里叶变换

$ x(t) = integral_(-oo)^(+oo) X(f) ee^(jj 2 pi f t) dd(f) $

能量信号 $x(t)$ 的能量谱密度

$ E_x (f) = abs(X(f))^2 $

能量信号 $x(t)$ , $y(t)$ 的互能量谱密度

$ E_(x y) (f) = X(f) Y^*(f) $

功率信号 $x(t)$ 的功率谱密度，截短信号 $x_T (t) = rect(hfrac(t, T)) x(t)$

$ P_x (f) = lim_(T -> oo) 1 / T abs(X_T (f))^2 $

功率信号 $x(t)$ , $y(t)$ 的互功率谱密度

$ P_(x y) (f) = lim_(T -> oo) 1 / T X_T (f) Y_T^* (f) $

=== 常用变换对及性质

面积和原点值

$
  x(0) & = integral_(-oo)^(+oo) X(f) dd(f) \
  X(0) & = integral_(-oo)^(+oo) x(t) dd(t) \
$

线性 $a x(t) + y(t) <=> a X(f) + Y(f)$

共轭 $x^*(t) <=> X^*(-f)$

奇偶性 $x(-t) <=> X(-f)$

对偶 $X(t) <=> x(-f)$

尺度变换 $x(a t) <=> (hfrac(1, abs(a))) X(hfrac(f, a))$

$rect$ 和 $sinc$ 的变换对

$
  rect(t) <=> sinc(f) \
  sinc(t) <=> rect(f) \
$

直流和冲激 $1 <=> delta(f), quad delta(t) <=> 1$

时移和频移

$
               x(t - t_0) & <=> X(f) ee^(-jj 2 pi f t_0) \
  x(t) ee^(jj 2 pi f_0 t) & <=> X(f - f_0) \
$

调制定理

$ x(t) cos(2 pi f_0 t) <=> 1 / 2 (X(f - f_0) + X(f + f_0)) $

微分

$
         dv(, t) x(t) & <=> jj 2 pi f dot X(f) \
  -jj 2 pi t dot x(t) & <=> dv(, f) X(f) \
$

周期冲激序列

$ sum_(n = -oo)^(+oo) delta(t - n T) <=> 1 / T sum_(n = -oo)^(+oo) delta(f - n / T) $

卷积定理

$
  (x * y)(t) & <=> X(f) Y(f) \
   x(t) y(t) & <=> (X * Y)(f) \
$

内积

$ integral_(-oo)^(+oo) x(t) y^*(t) dd(t) = integral_(-oo)^(+oo) X(f) Y^*(f) dd(f) $

Parseval定理

$ integral_(-oo)^(+oo) abs(x(t))^2 dd(t) = integral_(-oo)^(+oo) abs(X(f))^2 dd(f) $

=== 相关函数和谱

能量信号 $x(t)$ 的自相关函数

$ R_x (tau) = integral_(-oo)^(+oo) x(t + tau) x^*(t) dd(t) $

能量信号 $x(t)$ , $y(t)$ 的互相关函数

$ R_(x y) (tau) = integral_(-oo)^(+oo) x(t + tau) y^*(t) dd(t) $

功率信号 $x(t)$ 的自相关函数

$ R_x (tau) = overline(x(t + tau) x^*(t)) $

功率信号 $x(t)$ , $y(t)$ 的互相关函数

$ R_(x y) (tau) = overline(x(t + tau) y^*(t)) $

互相关函数的共轭对称性

$ R_(y x) (tau) = R_(x y)^* (-tau) $

自相关函数最大值

$ abs(R_x (tau)) <= R_x (0) $

相关定理

$ R_(x y) (tau) <=> E_(x y) (f) $

Wiener-Khinchin定理

$ R_(x y) (tau) <=> P_(x y) (f) $

能量守恒

$ E_x = integral_(-oo)^(+oo) E_x (f) dd(f) = R_x (0) $

功率守恒

$ P_x = integral_(-oo)^(+oo) P_x (f) dd(f) = R_x (0) $

== 线性滤波器

滤波器冲激响应为 $h(t)$ ，令 $g(t) = h^* (-t)$。输入为 $x(t)$ 时，输出为

$ y(t) = (x * h)(t) = R_(x g) (t) $

频域特性

$ Y(f) = H(f) X(f) $

无失真条件

$ H(f) = c dot ee^(-jj 2 pi f t_0) $

通过滤波器后的相关函数

$
  R_y (tau) = (R_X * h * g)(tau) \
  R_(x y) (tau) = (R_X * g)(tau) \
  R_(y x) (tau) = (R_X * h)(tau) \
$

== 带通信号表示

实信号 $x(t)$ 的希尔伯特变换

$ hat(x)(t) = 1 / pi pv integral_(-oo)^(+oo) x(tau) / (t - tau) dd(tau) $

逆希尔伯特变换

$ x(t) = -1 / pi pv integral_(-oo)^(+oo) (hat(x)(tau)) / (t - tau) dd(tau) $

希尔伯特变换的传递函数

$ H(f) = -jj sgn(f), quad abs(H(f))^2 = 1 $

正交关系

$ R_(hat(x) x) (0) = integral_(-oo)^(+oo) hat(x)(t) x(t) dd(t) = 0 $

实信号 $x(t)$ 的解析信号

$ z(t) = x(t) + jj hat(x)(t) $

解析信号频谱。$X_+ (f) = X(f) u(f)$ 表示正频率部分，$X_- (f) = X(f) u(-f)$ 表示负频率部分

$
      Z(f) & = 2 X_+ (f) \
  Z^* (-f) & = 2 X_- (f) \
$

相关函数关系

$
  R_z (tau) = 2 (R_x (tau) + jj hat(R)_x (tau)) \
  R_(z z^*) (tau) = 0 \
$

实信号 $x(t)$ 关于参考载波 $cos(2 pi f_c t + theta_c)$ 的复包络；$x_c (t)$ 为同相分量（I路分量），$x_s (t)$ 为正交分量（Q路分量）

$ x_L (t) = z(t) ee^(-jj (2 pi f_c t + theta_c)) = x_c (t) + jj x_s (t) $

逆关系

$ z(t) = x_L (t) ee^(jj (2 pi f_c t + theta_c)) $

复包络自相关函数

$ R_(x_L) (tau) = 2 (R_x (tau) + jj hat(R)_x (tau)) ee^(-jj 2 pi f_c tau) $

I/Q调制关系

$
  x(t) = & x_c (t) cos(2 pi f_c t + theta_c) \
         & class("binary", -) x_s (t) sin(2 pi f_c t + theta_c)
$

I/Q解调，相位不同步时，复包络整体旋转

$
     x(t) dot 2 cos(2 pi f_c t + theta) & = x_c (t) cos(theta_c - theta) + dots.c \
  x(t) dot (-2) sin(2 pi f_c t + theta) & = x_s (t) cos(theta_c - theta) + dots.c \
                                y_L (t) & = x_L (t) ee^(jj (theta_c - theta))
$

频谱关系

$
     X_L (f) & = 2 X_+ (f + f_c) \
  X_L^* (-f) & = 2 X_- (f + f_c) \
        X(f) & = (hfrac(1, 2)) (X_L (f - f_c) + X_L^* (-f - f_c)) \
     X_c (f) & = X_+ (f + f_c) + X_- (f - f_c) \
     X_s (f) & = X_+ (f + f_c) - X_- (f - f_c) \
$

系统等效基带表示

$ H_e (f) = 1 / 2 H_L (f) = H_+ (f + f_c) $

= 随机过程

== 基本概念

随机过程 $X(t)$ 的均值，也叫统计平均。平稳过程的均值与 $t$ 无关

$ m_X (t) = EX(X(t)) $

随机过程 $X(t)$ 的时间平均，是一个随机变量

$ overline(X(t)) = lim_(T -> oo) 1 / T integral_(-hfrac(T, 2))^(+hfrac(T, 2)) X(t) dd(t) $

统计平均和时间平均可交换（在可积的条件下）

$ EX(overline(X(t))) = overline(EX(X(t))) $

随机过程 $X(t)$ 的平均功率

$ P_X = overline(EX(abs(X(t))^2)) $

随机过程 $X(t)$ 的自相关函数

$ R_X (t_1, t_2) = EX(X(t_1) X^* (t_2)) $

随机过程 $X(t)$ ,$Y(t)$ 的互相关函数

$ R_(X Y) (t_1, t_2) = EX(X(t_1) Y^*(t_2)) $

随机过程 $X(t)$ 的平均自相关函数

$ overline(R)_X (tau) = overline(R_X (t + tau, t)) $

随机过程 $X(t)$ , $Y(t)$ 的平均互相关函数

$ overline(R)_(X Y) (tau) = overline(R_(X Y)(t + tau, t)) $

平稳过程 $X(t)$ 的自相关函数

$ R_X (tau) = EX(X(t + tau) X^*(t)) $

平稳过程 $X(t)$ , $Y(t)$ 的互相关函数

$ R_(X Y) (tau) = EX(X(t + tau) Y^*(t)) $

平稳过程 $X(t)$ 有遍历性即

$
  Pr(overline(X(t)) = m_X) = 1 \
  Pr(overline(X(t + tau) X^*(t)) = R_X (tau)) = 1
$

平稳过程 $X(t)$ 的功率谱密度，截短过程 $X_T (t) = rect(hfrac(t, T)) X(t)$

$ P_X (f) = lim_(T -> oo) 1 / T EX(abs(cal(F)(X_T (t)))^2) $

平稳过程 $X(t)$ , $Y(t)$ 的互功率谱密度

$
  P_(X Y) (f) = lim_(T -> oo) 1 / T EX(cal(F)(X_T (t)) (cal(F)(Y_T (t)))^*)
$

Wiener-Khinchin定理

$ overline(R)_(X Y) (tau) <=> P_(X Y) (f) $

随机过程 $X(t)$ 通过滤波器，输出 $Y(t)$

$
      P_Y (f) & = abs(H(f))^2 P_X (f) \
  P_(X Y) (f) & = H^*(f) P_X (f) \
  P_(Y X) (f) & = H(f) P_X (f) \
$

== AWGN

功率谱密度 $P_(n_w) (f) = hfrac(N_0, 2)$

自相关函数 $R_(n_w)(tau) = (hfrac(N_0, 2)) delta(tau)$

通过滤波器

$
  P_n (f) & = N_0 / 2 abs(H(f))^2 \
      P_n & = N_0 / 2 E_h \
$

$n_w (t)$ 和确定信号 $x(t),y(t)$ 的内积 $Z_x,Z_y $服从

$ Z_x ~ N(0, hfrac(N_0 E_x, 2)), quad EX(Z_x Z_y) = hfrac(N_0 E_(x y), 2) $

AWGN信道模型；发送信号 $s(t)$ ，接收信号 $r(t)$ ，噪声 $n_w (t)$ 独立

$ r(t) = s(t) + n_w (t) $

== 匹配滤波

滤波器在 $t = t_0$ 时刻的输出信号

$ y(t_0) = (s * h)(t_0) + (n_w * h)(t_0) = s_0 + Z $

$Z$ 的平均噪声功率 $P_n = (hfrac(N_0, 2)) E_h$

采样时刻信噪比 $gamma = hfrac(abs(s_0)^2, P_n)$

最大值条件

$ abs(s_0)^2 = abs(chevron.l h(t)\, s^*(t_0 - t) chevron.r)^2 <= E_h E_s $

最大信噪比 $ gamma_max = hfrac(2 E_s, N_0) $

对信号 $s(t)$ 匹配的匹配滤波器

$
  h(t) = K s^*(t_0 - t) \
  H(f) = K S^*(f) ee^(-jj 2 pi f t_0) \
$

= 模拟通信系统

== DSB-SC

=== 调制

已调信号

$
  s(t) = A_c m(t) cos(2 pi f_c t) \
  S(f) = A_c / 2 (M(f - f_c) + M(f + f_c)) \
  P_s (f) = A_c^2 / 4 (P_m (f - f_c) + P_m (f + f_c)) \
$

=== 相干解调

$phi.alt_c$ 为发端载波初相，$phi.alt$ 为收端载波相位

$ y_o (t) = A_c m(t) cos(phi.alt_c - phi.alt) $

=== 载波同步

/ 插入导频: 等效为 $m(t)$ 叠加直流 $hfrac(A_p, A_c)$，提取时用窄带滤波器或者锁相环

  $
    s(t) = & A_c m(t) cos(2 pi f_c t + phi.alt_c) \
           & class("binary", +) A_p cos(2 pi f_c t + phi.alt_c) \
  $

  锁相环用 $tilde(Q)(t)$ 负反馈，提取载波，锁定时输出

  $ tilde(I)(t) approx A_c m(t) + A_p $

/ 平方环: 平方得

  $ A_c^2 m^2(t) cos^2(2 pi f_c t + phi.alt_c) $

  锁相环提取 $cos(4 pi f_c t + 2 phi.alt_c)$ 后二分频得载波

  $ plus.minus cos(2 pi f_c t + phi.alt_c) $

  存在相位模糊
/ 科斯塔斯环: 用 $tilde(I)(t) tilde(Q)(t)$ 负反馈，锁定时解调输出

$ tilde(I)(t) approx plus.minus A_c m(t) $

  存在相位模糊

== AM

=== 调制

调幅系数 $a <= 1$。最大幅度归一化信号 $m_n (t) = hfrac(m(t) , abs(m(t))_max)$。AM可看成直流偏置后DSB调制、DSB-SC叠加载波。

$
  s(t) & = A_c (1 + a m_n (t)) cos(2 pi f_c t) \
       & = (A_c + A' m(t)) cos(2 pi f_c t) \
       & = A_c cos(2 pi f_c t) + A' m(t) cos(2 pi f_c t) \
$

频谱特性

$
     S(f) = & A' / 2 (M(f - f_c) + M(f + f_c)) \
          & class("binary", +) A_c / 2 (delta(f - f_c) + delta(f + f_c)) \
  P_s (f) = & (A')^2 / 4 (P_m (f - f_c) + P_m (f + f_c)) \
          & class("binary", +) A_c^2 / 4 (delta(f - f_c) + delta(f + f_c)) \
$

=== 解调

包络检波得 $A_c + A' m(t)$ ，隔直流后得 $A' m(t)$。

=== 调制效率

调制效率，$P_(m_n)$ 为 $m_n (t)$ 的功率

$ eta = ((A')^2 P_m) / (A_c^2 + (A')^2 P_m) = (a^2 P_(m_n)) / (1 + a^2 P_(m_n)) $

峰均比（PAPR）

$ C_m = abs(m(t))_max^2 / overline(m^2(t)) = P_(m_n)^(-1) $

调制效率、峰均比、调幅系数关系

$ eta = 1 / (1 + hfrac(C_m, a^2)) $

== SSB

上下边带SSB信号

$
  s_"USB" (t) & = A_c / 2 (m(t) cos(2 pi f_c t) - hat(m)(t) sin(2 pi f_c t)) \
  s_"LSB" (t) & = A_c / 2 (m(t) cos(2 pi f_c t) + hat(m)(t) sin(2 pi f_c t)) \
$

== VSB

带通滤波的等效基带传递函数 $H_e (f)$ 满足条件

$ H_e (f) + H_e^*(-f) = 1 $

带通滤波器 $H(f)$ 满足条件

$ H(f + f_c) + H(f - f_c) = 1, quad abs(f) <= f_c $

== PM/FM

PM/FM已调信号；$K_p$ 调相灵敏度，$K_f$ 调频灵敏度

$
  s_"PM" (t) & = A_c cos(2 pi f_c t + K_p m(t)) \
  s_"FM" (t) & = A_c cos(2 pi f_c t + 2 pi K_f integral_(-oo)^t m(tau) dd(tau))
$

瞬时频偏关系

$
  theta_p (t) & = K_p m(t) \
  1 / (2 pi) theta_m'(t) & = K_f m(t) \
$

FM最大频偏

$ difference(f_max) = K_f abs(m(t))_max $

调频指数，$m(t)$ 最高频率为 $W$

$ beta_f = hfrac(difference(f_max), W) $

最大幅度归一化信号 $m_n (t)$ 的形式。令 $tilde(m)(t) = 2 pi W integral_(-oo)^t m_n (tau) dd(tau)$

$ s_"FM" (t) = A_c cos(2 pi f_c t + beta_f tilde(m)(t)) $

单音信号 $m_n (t)=cos(2 pi f_m t)$ 的调频。此时 $W=f_m$

$ s_"FM" (t) = A_c cos(2 pi f_c t + beta_f sin(2 pi f_m t)) $

单音调频的复包络

$
  s_L (t) & = A_c ee^(jj beta_f sin(2 pi f_m t)) \
          & = A_c sum_(n = -oo)^(+oo) J_n (beta_f) ee^(jj 2 pi n f_m t)
$

单音调频复包络功率谱密度

$
  P_(s_L)(f) = A_c^2 sum_(n = -oo)^(+oo) J_n^2(beta_f) delta(f - n f_m)
$

带宽Carson公式

$ B approx 2 (beta_f + 1) W = 2 (difference(f_max) + W) $

窄带调频，$abs(theta(t) = beta_f tilde(m)(t))$ 非常小

$
  s_L (t) & = A_c ee^(jj beta_f tilde(m)(t)) \
          & approx A_c (1 + jj beta_f tilde(m)(t)) \
     s(t) & approx A_c cos(2 pi f_c t) - A_c beta_f tilde(m)(t) sin(2 pi f_c t)
$

=== 调制

直接调频采用VCO。间接调频先做窄带调频，再用 $n$ 倍频增大调频指数

$ f' = n f, quad beta_f' = n beta_f $

=== 解调

/ 微分包络检波法: 令 $v(t) = 1 / (2 pi) dv(, t) s(t)$ ，则

$
  v(t) = & -[f_c + K_f m(t)] \
       & class("binary", dot) sin(2 pi f_c t + 2 pi K_f integral_(-oo)^t m(tau) dd(tau))
$

$v(t)$ 经包络检波得 $f_c + K_f m(t)$ ，隔直流后为 $K_f m(t)$。

/ 锁相鉴频法: 锁相环锁定时，VCO调频灵敏度相同

$
  2 pi K_f integral_(-oo)^t m(tau) dd(tau) approx 2 pi K_f integral_(-oo)^t v(tau) dd(tau)
$

== 抗噪声性能对比

输入信噪比 $"SNR"_i = hfrac(P_R, N_0 B)$

相干解调相位不同步

$ "SNR"_o' = "SNR"_o cos^2(theta_e) $

#figure(table(
  columns: 4,
  inset: (x: .25em, y: .75em),
  table.header[调制][带宽 $B$][解调][$"SNR"_o$],
  [DSB-SC], $2 W$, [相干解调], $frac(P_R, N_0 W)$,
  [AM], $2 W$, [相干解调], $eta frac(P_R, N_0 W)$,
  [AM], $2 W$, [包络检波], $(eta frac(P_R, N_0 W))^*$,
  [SSB], $W$, [相干解调], $frac(P_R, N_0 W)$,
  [FM], $2 (beta_f + 1) W$, [鉴频器], $(frac(3 beta_f^2, C_m) frac(P_R, N_0 W))^*$,
))

\*大信噪比下近似。

== 频分复用

频分复用通常先用SSB, DSB，频带互不交叠，再FM调制后传输。解复用使用带通滤波。

= 数字基带传输

== 基本速率

比特速率 $R_b$ 和二进制比特间隔 $T_b$ 关系

$ R_b T_b = #qty[1][bit] $

比特速率 $R_b$ 和符号速率 $R_s$ 的关系。$M$ 进制符号

$ R_s = frac(R_b, log M) $

比特错误率 $P_b$ 与符号错误率 $P_s$ 关系

$ frac(P_s, log M) <= P_b <= P_s $

== PAM

$M$ 进制幅度序列。幅度 $a_n$ 有 $M$ 种取值，$M$ 进制符号间隔 $T_s$

$ sum_(n = -oo)^(+oo) a_n delta(t - n T_s) $

PAM信号一般表达式。发送滤波器冲激响应为 $g_T (t)$

$ s(t) = sum_(n = -oo)^(+oo) a_n g_T (t - n T_s) $

功率谱

$ P_s (f) = frac(1, T_s) sum_(n = -oo)^(+oo) R_a (n) ee^(jj 2 pi n f T_s) abs(G_T (f))^2 $

$(a_n)$ 是不相关序列，均值为 $m_a$，方差为 $sigma_a^2$

$
  P_s (f) = &  frac(sigma_a^2, T_s) abs(G_T (f))^2 \
          & class("binary", +) frac(m_a^2, T_s^2) sum_k abs(G_T (frac(k, T_s)))^2 delta(f - frac(k, T_s))
$

${a_n}$ 为零均值不相关序列时无离散谱

== 常用码型

单极性码的可能幅值为 $A$, $0$。双极性码的可能幅值为 $A$, $-A$。差分码满足 $b_n = a_n plus.o b_(n - 1)$。若原序列独立等概率，则差分码序列仍独立等概率。

矩形不归零脉冲，占空比 $100%$

$
  g_T (t) = A_b (u(t) - u(t - T_b)) \
  G_T (f) = A_b T_b sinc(f T_b) ee^(-jj pi f T_b) \
$

矩形归零脉冲，占空比 $50%$

$
  g_T (t) = u(t - T_b / 2) - u(t) \
  G_T (f) = A_b T_b / 2 sinc(f T_b / 2) ee^(-jj pi f hfrac(T_b, 2))
$

== 常用线路码型

AMI码：传号“1”交替反转。

$ R_m (0) = hfrac(1, 2), quad R_m (plus.minus 1) = -hfrac(1, 4) $

功率谱（占空比 $50%$）

$ P(f) = frac(T_b A_b^2, 4) sin^2(pi f T_b) sinc^2(frac(f T_b, 2)) $

$"HDB"_3$ 码：“1”交替反转，将四连“0”替换为取代节，插入破坏符号 $V$。

CMI码：将“0”编码为“01”，将“1”交替编码为“11”“00”。

数字双相码：将“0”编码为“01”，将“1”编码为“10”。

== AWGN 信道下的接收

双极性信号 $s(t) = plus.minus g(t)$

匹配滤波器 $h(t) = g(t_0 - t)$

平均比特能量 $E_b = E_g$

判决门限 $V_T = 0$

平均误比特率，只与比特信噪比 $E_b / N_0$ 有关

$ P_b = hfrac(1, 2) erfc(sqrt(frac(E_b, N_0))) $

单极性信号 $s(t) = g(t) "或" 0$

平均比特能量 $E_b = hfrac(E_g, 2)$

判决门限 $V_T = hfrac(E_g, 2)$

平均误比特率

$ P_b = hfrac(1, 2) erfc(sqrt(frac(E_b, 2 N_0))) $

== PAM有限带信道传输

PAM基带传输系统模型

$ g_T (t) -> c(t) -> + n_w (t) -> g_R (t) $

输出信号

$
  y(t) & = sum_(n = -oo)^(+oo) a_n x(t - n T_s) + gamma(t) \
  x(t) & = (g_T * c * g_R)(t) \
  gamma(t) & = (n_w * g_R)(t)
$

瞬时采样值

$
  y_m = x_0 a_m + sum_(n != m) a_n x_(m - n) + gamma_m
$

无ISI传输的Nyquist准则。假设理想基带信道

$
  x(n T_s) = delta(n) <=> sum_(n = -oo)^(+oo) X(f + frac(n, T_s)) = T_s
$

具体来说，当$X(f)$截止频率为$W$时

$T_s < 1/2W$：必有ISI

$T_s = 1/2W$：无ISI当且仅当

$
x(t)= sinc (2W t)
$

$T_s > 1/2W$：常用升余弦滚降系统，$0 <= alpha <= 1$满足无ISI

$
x_"rcos"(t)=sinc (frac(t, T_s)) frac(cos(frac(pi alpha t, T_s)),1-4(frac(alpha t,T_s))^2)
$

理想限带及加性白高斯噪声信道下PAM最佳基带传输（无ISI，误符号率最低）

$
G_T (f)=G_R (f)=sqrt(X_"rcos" (f))
$

= 数字频带传输

== 调制分类

- ASK（振幅键控）：控制载波幅度
- FSK（频率键控）：控制载波频率
- PSK（相位键控）：控制载波相位
- QAM（正交幅度调制）：联合控制载波幅度相位

== 相干接收
可以使用匹配滤波器加 $T_b$ 时刻采样，或者和基向量进行乘法后积分，以得到观察向量 $bold(r)$。二者是等价的，均为与基向量进行内积。相位未知不完全匹配时，接收的复包络会乘上一个因子 $ee^(jj theta)$，星座发生旋转。

*MAP 准则（最大后验概率准则）：*对于接收的观察向量$bold(r)$，选择 $Pr(s_i|bold(r))$ 最大的 $s_i$ 作为结果。等价于最大化 $Pr(s_i)Pr(bold(r)|s_i)$。按 MAP 准则判决可以使平均错判概率最小。

*ML 准则（最大似然准则）：* 先验概率 $Pr(s_i)$ 相等时，MAP 准则等价于最大化似然函数 $Pr(bold(r)|s_i)$ 。 AWGN 噪声下 ML 准则等价于最小化欧氏距离。

== OOK（2ASK）
默认采用单极性矩形不归零脉冲作为成形滤波器。

=== 星座图
规范正交基 $f_1 (t)=sqrt(frac(2,T_b)) cos(omega_c t)$

信号向量 $s_0 = 0, s_1 = sqrt(E_1)$

=== 功率谱密度
OOK 信号是 DSB 调制，功率谱密度是基带信号的频谱搬移
$
P_s (f) = frac(A^2, 4) [P_b (f-f_c) + P_b (f+f_c)]
$
使用单极性脉冲所以含有直流分量。
=== 非相干接收
匹配滤波后包络检波后采样，采样时刻的复包络为 $(a E_1 + Z) ee^(jj theta)$。判决门限为$E_1/2$。

=== 平均误比特率

平均比特能量$E_b=frac(E_1,2)$。

相干接收平均误比特率为

$
  1/2 erfc(sqrt(frac(E_1,4 N_0)))
$

非相干接收平均误比特率为

$
1/4 erfc(sqrt(frac(E_1,4 N_0))) + 1/2 exp(-frac(E_1,4N_0))
$

第二项在高信噪比下主导

== 2FSK
默认采用单极性矩形不归零脉冲作为成形滤波器。

=== 星座图
规范正交基
$
f_1 (t)=sqrt(frac(2,T_b)) cos(omega_1 t), f_2 (t)=sqrt(frac(2,T_b)) cos(omega_2 t)
$

信号向量 $s_0=(sqrt(E_b),0), s_1=(0,sqrt(E_b))$

=== 相关性
两个信号正交当且仅当 $Delta f$ 是 $hfrac(1, 2T_b)$ 的整数倍。

=== 非相干接收
先经过两种匹配滤波器，包络检波后采样，之后进行比较。相当于两个 OOK 非相干解调后比较。

=== 平均误比特率
相干接收平均误比特率为

$
  1/2 erfc(sqrt(frac(E_b,2 N_0)))
$

非相干接收平均误比特率为

$
1/2 exp(-frac(E_b,2N_0))
$

== 2PSK
默认采用双极性矩形不归零脉冲作为成形滤波器。

=== 星座图
规范正交基 $f_1 (t)=sqrt(frac(2,T_b)) cos(omega_c t)$

信号向量 $s_0=-sqrt(E_b), s_1=sqrt(E_b)$
=== 功率谱密度
2PSK 信号是 DSB 调制，功率谱密度是基带信号的频谱搬移
$
P_s (f) = frac(A^2, 4) [P_b (f-f_c) + P_b (f+f_c)]
$

使用双极性脉冲所以不含直流分量。

$
P_b (f) = T_b sinc^2(f T_b)
$
=== 平均误比特率
和双极性 PAM 一致为
$
1/2 erfc(sqrt(frac(E_b,N_0)))
$
=== DPSK
将输入信号差分编码再 2PSK，避免相位模糊。统计特征和 2PSK 完全相同。

== QPSK
=== 星座图
规范正交基
$
f_1 (t)=sqrt(frac(2,T_b)) cos(omega_c t), f_2 (t)=-sqrt(frac(2,T_b)) sin(omega_c t)
$

初始相位为 $0$ 的信号向量 
$
s_0=(sqrt(E_b),0), s_1=(0,sqrt(E_b)),\
s_2=(-sqrt(E_b),0), s_3=(0,-sqrt(E_b)).
$

初始相位为 $hfrac(pi,4)$ 的信号向量 
$
s_0=(sqrt(E_b/2),sqrt(E_b/2)), s_1=(-sqrt(E_b/2),sqrt(E_b/2)),\
s_2=(-sqrt(E_b/2),-sqrt(E_b/2)), s_3=(sqrt(E_b/2),-sqrt(E_b/2)).
$

=== 实现方式
初始相位为 $hfrac(pi,4)$ 的 QPSK 进行串并变换按格雷码映射，可以分为两路正交载波的 2PSK。格雷码可以使误比特率降低。

=== 功率谱密度
可以视为两正交载波 2PSK 叠加，功率谱密度为
$
P(f) = frac(A^2 T_b,2) (sinc^2[2(f-f_c)T_b] + sinc^2[2(f+f_c)T_b])
$

=== DQPSK
四进制差分编码按串并变换后分别进行差分，可以解决相位模糊问题，同时仍然具有格雷码的优点。

== MASK
=== 星座图
规范正交基 $f_1 (t)=sqrt(frac(2,E_g)) g_T (t) cos(omega_c t)$

信号向量 $s_i = sqrt(frac(E_g,2)) (2i-1-M)$

最小欧氏距离 $d_min = sqrt(2 E_g)$
=== 功率谱密度
$
 P_s (f) = frac(A^2, 4) [P_b (f-f_c)+P_b (f+f_c)]
$

=== 频带利用率
矩形脉冲成形滤波时，主瓣带宽 $2R_s = 2hfrac(R_b,log_2 M)$。

升余弦成形滤波时，绝对带宽 $hfrac(R_b (1+alpha),log_2 M)$。

=== 平均误符号率

$
P_M &= frac((M-1), M) erfc(sqrt(frac(E_g,2N_0))) \
&= frac((M-1), M) erfc(sqrt(frac(d_min^2,4N_0)))
$

平均误比特率采用格雷码 $P_B approx hfrac(P_M, log_2 M)$

== MPSK
默认采用矩形不归零脉冲作为成形滤波器。

=== 星座图
规范正交基
$
f_1 (t)=sqrt(frac(2,T_s)) cos(omega_c t),\ f_2 (t)=- sqrt(frac(2,T_s)) sin(omega_c t)
$

信号向量（初始相位为 $0$）
$
s_i = sqrt(E_s)[cos(frac(2pi,M) (i-1)), sin(frac(2pi,M) (i-1))]
$

最小欧氏距离
$
d_min = 2sqrt(E_s) sin frac(pi, M) = 2sqrt(E_b log_2 M) sin frac(pi, M)
$
=== 功率谱密度
二进制符号等概率出现且不相关时平均功率谱密度为
$
  P(f) = frac(E_s, 2) ( sinc^2[(f-f_s)T_s] + sinc^2[(f+f_s)T_s])
$

=== 平均误符号率
没有闭式解。上界为

$
P_M < erfc(sqrt(frac(E_s, N_0) sin^2 frac(pi, M)))
$

平均误比特率
$P_B approx hfrac(P_M, log_2 M)
$

== MFSK
=== 星座图
规范正交基
$
f_i (t) = sqrt(frac(2, T_s)) cos(omega_c t + i Delta omega t)
$
信号向量 $s_i = sqrt(E_s)e_i$

向量间欧氏距离均为
$sqrt(2E_s)$
=== 平均误符号率
没有闭式解。上界为
$
P_M <= frac(M-1,2) erfc(sqrt(frac(E_b log_2 M, 2N_0)))
$
平均误比特率
$P_B = hfrac(M,[2(M-1)]) P_M$

$M$ 很大近似为 $P_B approx hfrac(1,2) P_M $

=== 频带利用率
主瓣带宽
$B = hfrac((M+3), T_s)$


$M$ 很大近似为
$B approx hfrac(M, T_s)$

== MQAM
=== 星座图

规范正交基
$
f_1 (t)=sqrt(frac(2,E_g)) g_T (t) cos(omega_c t),\ f_2 (t)=-sqrt(frac(2,E_g)) g_T (t) sin(omega_c t)
$

矩形星座的实现，做串并变换后两个支路分别按速率减半的 $sqrt(M)$ 进制 ASK 调制。

最小欧氏距离
$
d_min = sqrt(2E_g) = sqrt(frac(6 E_b log_2 M, M-1))
$

=== 平均误符号率
矩形星座 MQAM的误符号率约为
$
P_M approx 2(1-frac(1,sqrt(M)))erfc(sqrt(frac(3, 2(M-1)) frac(E_s, N_0)))
$

误比特率
$P_B approx frac(P_M, log_2 M)$

=== 频带利用率
矩形脉冲成形时，主瓣带宽 $2R_s = 2hfrac(R_b,log_2 M)$。

升余弦成形滤波时，绝对带宽 $hfrac(R_b (1+alpha),log_2 M)$。

= 信息论
== 基本概念
事件 $X$ 的信息熵
$
  H(X) = EX[-log Pr(x_i)] = - sum_i Pr(x_i)log Pr(x_i)
$
事件 $X, Y$ 的联合熵
$
  H(X,Y) &= EX[-log Pr(x_i, y_j)] \
  &= - sum_(i j) Pr(x_i, y_j)log Pr(x_i, y_j)
$

事件 $X, Y$ 的条件熵
$
  H(X|Y) &= EX[-log Pr(x_i,y_j)]\
  &= - sum_(i j) Pr(x_i y_j)log Pr(x_i| y_j)
$

条件熵性质
$
  H(X,Y) = H(X) + H(Y|X) = H(Y) + H(X|Y)
$

事件 $X, Y$ 的互信息
$
  I(X;Y) = H(X)+H(Y)-H(X, Y)
$

香农不等式
$
  H(X)>= H(X|Y)\
  H(Y)>= H(Y|X)\
  I(X;Y) >=0\
  I(X;Y) <= H(X)\
  I(X;Y) <= H(Y)\
$

== 等长编码定理
一个离散无记忆信源 $X$，熵为 $H(X)$，对信源按长度 $n$ 分组进行 $D$ 进制等长编码。码率 $R = hfrac(L_n, n)$。

若 $R >  hfrac(H(X), log D)$ 则存在编码使错误概率任意小。
若 $R <  hfrac(H(X), log D)$ 则几乎必定出错。

== 变长编码定理
一个离散无记忆信源 $X$，熵为 $H(X)$，对信源按长度 $n$ 分组进行 $D$ 进制变长编码，码率 $R = hfrac(overline(L)_n, n)$。对于任何唯一可译编码，码率 $R >= hfrac(H(X), log D)$，并且存在编码使之任意接近这个下界。

编码效率
$eta = hfrac(H(X),(R log D))$

== Huffman 码
对于已知概率分布的离散无记忆信源，给出最优前缀码。

== 信道

=== 信道模型
连续信道视为对输入应用时变线性算子后再叠加一个独立噪声。离散信道视为一个转移概率矩阵。

=== 信道性质
理想无失真条件 $H(f) =a ee^(-jj 2pi f t_0)$。

复包络无失真条件 $H(f) =a ee^(-jj (2pi f t_0 - theta))$。

信道小尺度衰落由多径效应和多普勒效应引起。

=== 信道容量
信道输入为 $X$，输出为$Y$，信道转移概率为 $P(Y|X)$。当转移概率确定时，改变 $P(X)$，互信息 $I(X;Y)$ 的最大值称为信道容量。

==== BSC（二元对称信道）
比特有 $mu$ 概率翻转，信道容量 
$
C = 1+ mu log mu +(1-mu) log (1-mu)
$

==== 时间离散的 AWGN 信道

输出 $Y=X+Z$，$X$ 的功率为 $S$，独立噪声 $Z ~ N(0,sigma^2)$。信道容量
$
C = 1/2 log(1+frac(S, sigma^2)) quad hfrac(bit,"symbol")
$

==== 带宽为 $B$ 的 AWGN 信道

输出 $Y(t) = X(t) + n(t)$，信道限带无失真，$n(t)$ 为功率 $ sigma^2 = N_0 B$ 的限带白噪声。信道容量

$
C = B log(1+frac(S, N_0 B)) quad hfrac(bit,"s")
$

每传输一比特信息，所需能量至少为 $(ln 2) N_0$

=== 信道编码定理
对于离散无记忆信道，容量为 $C$，传输码率 $R = frac(log M,n)$。若 $R<C$ 则存在信道编码使得错误率任意小，若 $R>C$ 则错误率无法达到任意小。

= 模拟信号数字化
== 低通采样定理
对频率在 $[0, f_H]$ 范围内的低通信号，采样恢复无混叠失真当且仅当采样频率 $f_s >= 2 f_H$。
== 带通采样定理
对频率在 $[f_L, f_H]$ 范围内的带通信号，令$B = f_H-f_L$，采样恢复无混叠失真当且仅当采样频率 $2 B (1+m/k) <= f_s <= 2B (1+frac(m,k-1))$。其中 $k = floor(f_H/B), m = hfrac(f_H,B) - k$。

== 标量量化
量化器输入模拟输入 $x(t)$，样值位于 $(x_(k-1), x_k)$ 时输出 $y_k$。

量化噪声 $e_q = y-x$

量化信噪比 $hfrac(S,N_q) = hfrac(EX[x^2], EX[e_q^2])$。

=== 均匀量化
将工作范围 $(-V, +V)$ 均匀分割为 $M$ 个 长为 $Delta = hfrac(2V, M)$ 的量化区间，量化电平位于区间中点。

输入均匀分布时，$S = hfrac(V^3,3)$，$N_q = hfrac(V^2,3M^2)$，量化信噪比 $M^2$。

=== 对数量化
用 $c(x)$ 非线性压缩后均匀量化。

$A$ 律，13折线近似
$
c(x) = cases(frac(A x,1+ln A)\,0 <= x <= 1/A, 
frac(1+ln A x,1+ln A)\,1/A <= x <= 1
)
$

$mu$ 律，15折线近似
$
c(x) = frac(ln(1+mu x), ln (1+mu)),0<=x<=1
$

= 信道编码
== 线性码
线性码分组码编码满足线性性。$(n,k)$线性分组码把 $k$ 比特信息分组编码为 $n$ 比特码字。系统码中原信息分组不变地出现，$k$位信息位，$m=n-k$ 位监督位。

汉明距离：码字间不同位个数。

码重：码字到 $bold(0)$ 的汉明距离。最小码重等于码字最小距离。

输入信息位 $bold(u)$ 作为行向量。

生成矩阵 $bold(G) =  mat(bold(I_k) &| &bold(Q))$。对应码字 $bold(c) = bold(u)bold(G)$。

监督矩阵 $bold(H) = mat(bold(Q)^T & | & bold(I)_m)$，满足 $bold(G)bold(H)^T = bold(0)$。

错误图样 $bold(e)$，校验子 $bold(s) = bold(y) bold(H)^T = bold(e)bold(H)^T$。

可纠正错误图样 $bold(e)_0$ 为方程最小的码重的解。

线性码可 $t$ 位纠错当且仅当最小码重大于等于 $2t + 1$，当且仅当 $bold(H)$ 任意 $t$ 列线性无关。

汉明码码长 $2^m -1$，监督位 $m$，监督矩阵 $bold(H)$ 每一列均不相同且不为 $0$，可以一位纠错。

== 循环码
循环码是满足循环移位封闭性的线性码。码字对应 $n-1$ 次多项式，即 $bb(F)_2[x]\/(x^n+1)$ 的元素。

循环码的生成多项式是除 $0$ 以外最低次的码多项式。

生成多项式唯一，为 $x^n+1$ 的因子，次数为 $n-k$，所有码多项式都是其倍数。

m 序列是线性反馈移位寄存器所能产生的最长的序列，具有伪随机性。其反馈多项式是本原多项式，不可约且根的阶为 $2^n -1$。

BCH 码的生成多项式为 $lcm[m_1(x), dots , m_(2t-1) (x)]$，其中 $m_i (x)$ 是不可约多项式，纠错个数为 $t$。

== 卷积码

卷积码的输出为最近 $K$ 个时刻的信息位（每段长度为$k$）分别和 $n$ 个序列卷积的 $n$ 个结果。可以视为 $k$ 个幂级数和 $n$ 个多项式分别作乘法。可以转化为有限状态自动机实现。 

== 交织
交织与反交织将突发差错引发的连续差错分散。矩阵交织器按列写入矩阵，按行读出矩阵；去交织器正相反。

= 扩频通信

直扩信号为信息信号 $d(t)$ 和扩频序列信号 $c(t)$ 的乘积。扩频信号相关特性好，抗干扰。扩频序列一般采用伪随机码和正交码。

采用正交码，扩频系数为 $N$ 时，带宽扩展 $N$ 倍。

== Walsh 码

Hadamard 矩阵 $bold(H) = mat(1 , 1 ; 1 , -1)$ 为正交矩阵。

$H^(⊗ n)$ 是正交矩阵，其行构成 Walsh 基函数。

= OFDM
OFDM 将高速串行数据分流到多个低速正交子载波上传输，允许子载波频谱重叠且互不干扰。在每个符号前插入循环前缀以消除 ISI，将线性卷积转为循环卷积，简化均衡。

优点
- 抗频率选择性衰落
- 高频谱效率
- 抗窄带干扰