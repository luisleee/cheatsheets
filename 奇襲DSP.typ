#import "/typ-layout/common.typ": cheatsheet
#import "typ-layout/math-util.typ": *

#let FFT = math.op("FFT")

#show: cheatsheet.with(title: "奇襲DSP")

#title({
  show regex("[a-zA-Z]+"): it => {
    let s = it.text
    text(fill: rgb(0, 0, 255), s.first())
    s.slice(1)
  }
  [奇襲 Digital Signal Processing ☞]
})

= 基本约定

记连续时间信号为 $x(t)$。记离散时间信号即序列为 $x(n)$，其Z变换为 $X(z)$，其DTFT为 $X(ee^(jj omega))$，DFT为 $X(k)$。记周期序列为 $tilde(x)(n)$，也可以表示为 $x(n)$ 的周期延拓，其DFS为 $tilde(X)(k)$。所有提到的系统都默认为线性时不变系统。$<=>$ 表示变换对，代表的变换具体视上下文而定。文中的 $delta$ 对离散时间序列表示Kronecker $delta$，对连续时间序列表示Dirac $delta$。复分析相关定理假设曲线是简单的，$Res[f(z),z_0]$ 表示函数 $f(z)$ 在点 $z_0$ 处的留数。Z 变换默认使用双边变换，性质部分忽略收敛域。对有限长序列进行操作时，当下标超出定义范围，默认按周期延拓处理。用 $times.o$ 表示有限长序列的循环卷积，卷积长度默认相同。$u(n)$ 表示单位阶跃函数，即 $n >= 0$ 时为 $1$，否则为 $0$。

= 基本性质

== 旋转因子（单位根）

记 $N$ 次单位根（旋转因子）为 $W_N = ee^hfrac(-jj 2 pi, N)$

分圆方程 $sum_(n = 0)^(N-1) W_N^k = 0$

完备正交性 $(hfrac(1, N)) sum_(n = 0)^(N-1) W_N^(n k) = delta(k), k in {0, 1, dots.c, N - 1}$

== 复变函数与留数

Cauchy积分公式 $2 pi jj f^((n)) (z_0) = n! integral.cont_Gamma f(z) (z - z_0)^(-n - 1) dd(z)$

留数定理 $integral.cont_Gamma f(z) dd(z) = 2 pi jj sum_k Res[f(z), z_k]$

极点留数求法：若 $z_0$ 为 $f(z)$ 的 $n$ 阶极点

$ Res[f(z), z_0] = 1 / (n - 1)! lim_(z -> z_0) dv(, z, n - 1) [(z - z_0)^n f(z)] $

特别地，对一阶极点：$Res[f(z), z_0] = lim_(z -> z_0) (z - z_0) f(z)$。

== 信号抽样

连续信号 $x_a (t)$ 按取样间隔 $T_s$ 取样，频率 $f_s = 1 / T_s$，得离散信号 $x(n) = x_a (n T_s)$。取样函数 $p(t) = sum_(n = -oo)^(+oo) delta(t - n T_s)$，理想取样信号 $hat(x)_a (t) = x_a (t) p(t)$。

模拟抽样角频率 $Omega_s = 2 pi / T_s$，频谱展开为：

$ hat(X)_a (jj Omega) = Omega_s sum_(n = -oo)^(+oo) X_a (jj (Omega - n Omega_s)) $

Nyquist取样定理：取样频率 $f_s >= 2 f_m$ ($f_m$ 是原信号最高频率) 时，可通过理想低通滤波器(理想内插)无失真恢复原信号。

时域频域取样定理：时域取样对应频域周期延拓；频域取样对应时域周期延拓。

模拟角频率 #qty($Omega$)[(#unit($"rad" / "s"$))] 与数字角频率 #qty($omega$)[(#unit[rad])] 关系为 $omega = Omega T_s = hfrac(Omega, f_s)$。

= DFS

周期为 $N$ 的序列 $tilde(x)(n)$ 的DFS变换对

$
   tilde(X)_n & = sum_(n = 0)^(N - 1) tilde(x)(n) W_N^(n k) \
  tilde(x)(n) & = 1 / N sum_(k = 0)^(N - 1) tilde(X)(k) W_N^(-n k) \
$

= DTFT

== 定义

序列 $x(n)$ 的DTFT

$ X(ee^(jj omega)) = sum_(n = -oo)^(+oo) x(n) ee^(-jj n omega) $

反变换IDTFT

$ x(n) = 1 / (2 pi) integral_(-oo)^(+oo) X(ee^(jj omega)) ee^(jj n omega) dd(omega) $

== 性质

线性 $a x(n) + y(n) <=> a X(ee^(jj omega)) + Y(ee^(jj omega))$

共轭 $x^*(n) <=> X^*(ee^(-jj omega))$

奇偶 $x(-n) <=> X(ee^(-jj omega))$

周期 $X(ee^(jj omega)) = X(ee^(jj (omega + 2 pi)))$

时移和频移

$
              x(n - n_0) & <=> ee^(-jj n_0 omega) X(ee^(jj omega)) \
  ee^(jj n omega_0) x(n) & <=> X(ee^(jj (omega - omega_0))) \
$

频域微分

$ n x(n) <=> jj dv(X(ee^(jj omega)), omega) $

周期冲激序列

$
  sum_(k = -oo)^(+oo) delta(n - k N) <=> (2 pi) / N sum_(k = -oo)^(+oo) delta(omega - (2 pi k) / N)
$

卷积定理

$
  x(n) * y(n) & <=> X(ee^(jj omega)) Y(ee^(jj omega)) \
    x(n) y(n) & <=> 1 / (2 pi) X(ee^(jj omega)) * Y(ee^(jj omega)) \
$

内积

$
  sum_(n = -oo)^(+oo) x(n) y^*(n) = 1 / (2 pi) integral_(-pi)^(pi) X(ee^(jj omega)) Y^*(ee^(jj omega)) dd(omega)
$

Parseval 定理

$
  sum_(n = -oo)^(+oo) abs(x(n))^2 = 1 / (2 pi) integral_(-pi)^(pi) abs(X(ee^(jj omega)))^2 dd(omega)
$

= Z变换

== 定义

序列 $x(n)$ 的Z变换 $X(z) = sum_(n = -oo)^(+oo) x(n) z^(-n)$

== 性质

将 $z = ee^(jj omega)$ 代入 $X(z)$ 得DTFT

反变换，$C$“内部”包含 $X(z)$ 所有极点

$ x(n) = 1 / (2 pi jj) integral.cont_C X(z) z^(n - 1) dd(z) = sum_(p_k) Res[X(z) z^(n - 1), p_k] $

线性 $a x(n) + y(n) <=> a X(z) + Y(z)$

共轭 $x^*(n) <=> X^*(z^*)$

时移 $x(n - n_0) <=> z^(-n_0) X(z)$

尺度变换 $a^n x(n) <=> X(hfrac(z, a))$

微分 $n x(n) <=> -z dv(, z) X(z)$

卷积 $x(n) * y(n) <=> X(z) dot Y(z)$

== 常见Z变换

#figure(table(
  columns: 3,
  table.header[序列][Z变换][收敛域],
  $delta(n)$, $1$, $CC$,
  $u(n)$, $1 / (1 - z^(-1))$, $abs(z) > 1$,
  $-u(-n - 1)$, $1 / (1 - z^(-1))$, $abs(z) < 1$,
  $sin(omega_0 n) u(n)$,
  $(sin(omega_0 n) z^(-1)) / (1 - 2 cos(omega_0) z^(-1) + z^(-2))$,
  $abs(z) > 1$,

  $cos(omega_0 n) u(n)$,
  $(1 - cos(omega_0) z^(-1)) / (1 - 2 cos(omega_0) z^(-1) + z^(-2))$,
  $abs(z) > 1$,

  $n u(n)$, $z^(-1) / (1 - z^(-1))^2$, $abs(z) > 1$,
  $-n u(-n - 1)$, $z^(-1) / (1 - z^(-1))^2$, $abs(z) < 1$,
))

= 离散系统性质

/ 因果性: 充要条件：$h(n) = 0$ ($n < 0$)；频域表现：$H(z)$收敛域包含 $oo$。
/ 稳定性: 充要条件：$sum_(n = -oo)^(+oo) abs(h(n)) < oo$；频域表现：$H(z)$收敛域包含单位圆。
/ 因果稳定系统分解: 可分解为全通与最小相位系统级联：$H(z) = H_min (z) dot H_"ap" (z)$。
/ 全通系统: 因果稳定，幅频响应恒为常数 ($abs(H_"ap" (ee^(jj omega)))^2 = 1$)。其零极点互为共轭倒置：

  $ H_"ap" (z) = A product_(k = 1)^N (z^(-1) - z_k^*) / (1 - a_k z^(-1)), quad abs(a_k) < 1 $

/ 最小相位系统: 因果稳定，所有零极点均在单位圆内。在相同幅频响应的因果稳定系统中，其相位延迟最小。其逆系统 $hfrac(1, H(z))$ 也是因果稳定的。
/ FIR系统: $h(n)$ 长度有限，无反馈，系统函数为 $z^(-1)$ 的多项式；永远稳定，极点全在 $z = 0$。
/ IIR系统: $h(n)$ 长度无限，有反馈，系统函数为有理分数；不一定稳定。

= DFT

== 定义

长度为 $N$ 的序列 $x(n)$ 的DFT

$ X(k) = sum_(n = 0)^(N - 1) x(n) W_N^(n k) $

反变换IDFT

$ x(n) = 1 / N sum_(k = 0)^(N - 1) X(k) W_N^(-n k) $

== 性质

$X(k)$ 周期延拓得 $tilde(X)(k)$，即 $tilde(x)(n)$ 的DFS

从Z变换得DFT

$ X(k) = evaluated(X(z))_(z = W_N^k) $

Z域内插

$
    X(z) & = sum_(k = 0)^(N - 1) X(k) Phi(W_N^k z) \
  Phi(z) & = 1 / N dot (1 - z^(-N)) / (1 - z^(-1)) \
$

频域内插

$
  X(ee^(jj omega)) & = sum_(k = 0)^(N - 1) X(k) Phi(omega - (2 pi k) / N) \
  Phi(omega) & = 1 / N dot sin(N hfrac(omega, 2)) / sin(hfrac(omega, 2)) ee^(-hfrac(jj (N - 1) omega, 2)) = evaluated(Phi(z))_(z = ee^(jj omega)) \
$

线性 $a x(n) + y(n) <=> a X(k) + Y(k)$

对偶 $X(n) <=> N x(k)$

共轭 $x^*(n) <=> X^*(-k)$

奇偶 $x(-n) <=> X(-k)$

时移和频移

$
         x(n - n_0) & <=> W_N^(n_0 k) X(k) \
  W_N^(-n k_0) x(n) & <=> X(k - k_0) \
$

内积 $sum_(n = 0)^(N - 1) x(n) y^*(n) = 1 / N sum_(k = 0)^(N - 1) X(k) Y^*(k)$

Parseval 定理 $sum_(n = 0)^(N - 1) abs(x(n))^2 = 1 / N sum_(k = 0)^(N - 1) abs(X(k))^2$

循环卷积定义

$ x(n) times.o y(n) = sum_(k = 0)^(N - 1) x(k) y(n - k) $

循环卷积定理

$
  x(n) times.o y(n) & <=> X(k) Y(k) \
          x(n) y(n) & <=> 1 / N X(k) times.o Y(k) \
$

== 计算线性卷积

/ 重叠相加法: 计算 $x(n) * h(n)$，$h(n)$ 长度为 $M$。将 $x(n)$ 分为长度为 $N$ 的不重叠段，每段补零后用 $N + M - 1$ 点循环卷积计算线性卷积，结果重叠相加。
/ 重叠保留法: 计算 $x(n) * h(n)$，$h(n)$ 长度 $M$。将 $x(n)$ 分为长度 $N$ 的段，段间重叠 $M - 1$ 点。每段做 $N$ 点循环卷积，每段输出保留后 $N - M + 1$ 点，丢弃前 $M - 1$ 点，直接拼接。

== 频谱分析

取样频率 $f_s$，做 $N$ 点DFT时

周期 $M$ 信号频谱泄漏不发生当且仅当 $M divides N$

谱线 $X(k)$ 代表的频率 $omega_k = (2 pi k) / N$

频率分辨率 $difference(f) = hfrac(f_s, N)$
最小频率偏差 $difference(omega) = min_k abs((2 pi) / M - (2 pi k) / N)$

= 基2-FFT

长度 $N$ 是 $2$ 的整数幂。所需复数乘法次数为 $(hfrac(N, 2)) log_2 N$。

== DIT-FFT

分成奇偶 $x_1(r) = x(2 r), x_2(r) = x(2 r + 1)$。

$
  X(k) & = X_1(k) + W_N^k X_2(k) \
  X(k + hfrac(N, 2)) & = X_1(k) - W_N^k X_2(k) \
$

== DIF-FFT

$
  X(2 r) & = FFT{ x(n) + x(n + hfrac(N, 2)) } \
  X(2 r + 1) & = FFT{ (x(n) - x(n + hfrac(N, 2))) W_N^n } \
$

== IFFT

共轭法 $x(n) = (hfrac(1, N)) (FFT{ X^*(k) })^*$
