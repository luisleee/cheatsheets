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

除非特别说明，下面的叙述全部关于复信号。记号上虚数单位用 $jj$ 表示，用 $(dot)^*$ 表示复共轭，上划线 $overline((dot))$ 表示时间平均。复内积都保持第一个位置线性，第二个位置共轭线性。卷积用 $*$ 表示。傅里叶变换采用模拟频率 $f$ 的形式，用 $cal(F)[dot]$ 表示，变换对用 $<=>$ 表示。柯西主值用 $pv$ 表示。对随机变量的积分和极限都是均方意义下的。$log$ 表示以 $2$ 为底的对数。

== 常用函数性质

单位冲激信号$(f * delta)(t) = f(t)$

阶跃函数 $u(t) = (hfrac(1, 2)) (1 + sgn(t))$

采样函数 $Sa(t) = hfrac((sin t), t)$ , $Sa(0)=1$

$sinc$ 脉冲 $sinc(t) = Sa(pi t)$

单位矩形脉冲 $rect(t) = u(t - (hfrac(1, 2))) - u(t + (hfrac(1, 2)))$

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

$ overline(x(t)) = lim_(T -> oo) 1 / T integral_(-hfrac(-T, 2))^(+hfrac(T, 2)) x(t) dd(t) $

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

平稳过程 $X(t)$ 遍历的即

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

$n_w (t)$ 和确定信号 $x(t)$ 的内积服从

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

== 噪声信道下的接收

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
