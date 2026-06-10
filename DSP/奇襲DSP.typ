#import "/typ-layout/common.typ": cheatsheet
#import "/typ-layout/math-util.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let FFT = math.op("FFT")
#let Zee = math.op(math.cal("Z"))
#let Laplace = math.op(math.cal("L"))

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

记连续时间信号为 $x(t)$。记离散时间信号即序列为 $x(n)$，其Z变换为 $X(z)$，其DTFT为 $X(ee^(jj omega))$，DFT为 $X(k)$。记周期序列为 $tilde(x)(n)$，也可以表示为 $x(n)$ 的周期延拓，其DFS为 $tilde(X)(k)$。所有提到的系统都默认为线性时不变系统。$<=>$ 表示变换对，代表的变换具体视上下文而定。文中的 $delta$ 对离散时间序列表示Kronecker $delta$，对连续时间序列表示Dirac $delta$。复分析相关定理假设曲线是简单的，$Res[f(z),z_0]$ 表示函数 $f(z)$ 在点 $z_0$ 处的留数。Z 变换默认使用双边变换，性质部分忽略收敛域。对有限长序列进行操作时，当下标超出定义范围，默认按周期延拓处理。用 $times.o$ 表示有限长序列的循环卷积，卷积长度默认相同。$u(n)$ 表示单位阶跃函数，即 $n >= 0$ 时为 $1$，否则为 $0$。$I_0 (beta)$表示零阶第一类修正贝塞尔函数。

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

内积 $sum_(n = -oo)^(+oo) x(n) y^*(n) = 1 / (2 pi) integral_(-pi)^(pi) X(ee^(jj omega)) Y^*(ee^(jj omega)) dd(omega)
$

Parseval 定理 $sum_(n = -oo)^(+oo) abs(x(n))^2 = 1 / (2 pi) integral_(-pi)^(pi) abs(X(ee^(jj omega)))^2 dd(omega)
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

#let p0 = -0.6
#let p1 = 0.0
#let p2 = 1.0
#let p3 = 2.3
#let p4 = 3.8
#let p5 = 5.1
#let p6 = 6.2
#let pX = 6.8

长度 $N$ 是 $2$ 的整数幂。所需复数乘法次数为 $(hfrac(N, 2)) log_2 N$。原址计算时将二进制编码颠倒进行混序。

== DIT-FFT

分成奇偶 $x_1(r) = x(2 r), x_2(r) = x(2 r + 1)$。

$
  X(k) & = X_1(k) + W_N^k X_2(k) \
  X(k + hfrac(N, 2)) & = X_1(k) - W_N^k X_2(k) \
$

输入混序。

#figure(text(size: 0.40em, diagram(
  cell-size: 2.0mm,
  node-stroke: .28pt,
  edge-stroke: .35pt,
  node-inset: .08em,

  node((p0, 0.0), [$x(0)$], fill: none, stroke: none),
  node((p0, 1.0), [$x(2)$], fill: none, stroke: none),
  node((p0, 2.0), [$x(1)$], fill: none, stroke: none),
  node((p0, 3.0), [$x(3)$], fill: none, stroke: none),

  node((p1, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p1, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p1, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p1, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((p2, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p2, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p2, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p2, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((p3, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p3, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p3, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p3, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((p4, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p4, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p4, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p4, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((p5, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p5, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p5, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p5, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((pX, 0.0), [$X(0)$], fill: none, stroke: none),
  node((pX, 1.0), [$X(1)$], fill: none, stroke: none),
  node((pX, 2.0), [$X(2)$], fill: none, stroke: none),
  node((pX, 3.0), [$X(3)$], fill: none, stroke: none),

  edge((p1, 0.0), (1.0, 0.0), "-|>"),
  edge((p1, 1.0), (1.0, 1.0), "-|>", label: $W_4^0$),
  edge((p1, 2.0), (1.0, 2.0), "-|>"),
  edge((p1, 3.0), (1.0, 3.0), "-|>", label: $W_4^0$),

  edge((p2, 0.0), (p3, 0.0), "-|>"),
  edge((p2, 1.0), (p3, 0.0), "-|>"),
  edge((p2, 0.0), (p3, 1.0), "-|>"),
  edge((p2, 1.0), (p3, 1.0), "-|>", label: $-1$),

  edge((p2, 2.0), (p3, 2.0), "-|>"),
  edge((p2, 3.0), (p3, 2.0), "-|>"),
  edge((p2, 2.0), (p3, 3.0), "-|>"),
  edge((p2, 3.0), (p3, 3.0), "-|>", label: $-1$),

  edge((p3, 0.0), (p4, 0.0), "-|>"),
  edge((p3, 1.0), (p4, 1.0), "-|>"),
  edge((p3, 2.0), (p4, 2.0), "-|>", label: $W_4^0$),
  edge((p3, 3.0), (p4, 3.0), "-|>", label: $W_4^1$),

  edge((p4, 0.0), (p5, 0.0), "-|>"),
  edge((p4, 2.0), (p5, 0.0), "-|>"),
  edge((p4, 1.0), (p5, 1.0), "-|>"),
  edge((p4, 3.0), (p5, 1.0), "-|>"),
  edge((p4, 0.0), (p5, 2.0), "-|>"),
  edge((p4, 2.0), (p5, 2.0), "-|>", label: $-1$),
  edge((p4, 1.0), (p5, 3.0), "-|>"),
  edge((p4, 3.0), (p5, 3.0), "-|>", label: $-1$),

  edge((p5, 0.0), (p6, 0.0), "-|>"),
  edge((p5, 1.0), (p6, 1.0), "-|>"),
  edge((p5, 2.0), (p6, 2.0), "-|>"),
  edge((p5, 3.0), (p6, 3.0), "-|>")
)))


== DIF-FFT

$
  X(2 r) & = FFT{ x(n) + x(n + hfrac(N, 2)) } \
  X(2 r + 1) & = FFT{ (x(n) - x(n + hfrac(N, 2))) W_N^n } \
$

输出混序。

#figure(text(size: 0.40em, diagram(
  cell-size: 2.0mm,
  node-stroke: .28pt,
  edge-stroke: .35pt,
  node-inset: .08em,
  node((p0, 0.0), [$x(0)$], fill: none, stroke: none),
  node((p0, 1.0), [$x(1)$], fill: none, stroke: none),
  node((p0, 2.0), [$x(2)$], fill: none, stroke: none),
  node((p0, 3.0), [$x(3)$], fill: none, stroke: none),

  node((p1, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p1, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p1, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p1, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((p2, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p2, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p2, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p2, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((p3, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p3, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p3, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p3, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((p4, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p4, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p4, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p4, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((p5, 0.0), [], radius: .10mm, fill: black, stroke: none),
  node((p5, 1.0), [], radius: .10mm, fill: black, stroke: none),
  node((p5, 2.0), [], radius: .10mm, fill: black, stroke: none),
  node((p5, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((pX, 0.0), [$X(0)$], fill: none, stroke: none),
  node((pX, 1.0), [$X(2)$], fill: none, stroke: none),
  node((pX, 2.0), [$X(1)$], fill: none, stroke: none),
  node((pX, 3.0), [$X(3)$], fill: none, stroke: none),

  edge((p1, 0.0), (p2, 0.0), "-|>"),
  edge((p1, 1.0), (p2, 1.0), "-|>"),
  edge((p1, 2.0), (p2, 2.0), "-|>"),
  edge((p1, 3.0), (p2, 3.0), "-|>"),

  edge((p2, 0.0), (p3, 0.0), "-|>"),
  edge((p2, 2.0), (p3, 0.0), "-|>"),
  edge((p2, 1.0), (p3, 1.0), "-|>"),
  edge((p2, 3.0), (p3, 1.0), "-|>"),
  edge((p2, 0.0), (p3, 2.0), "-|>"),
  edge((p2, 2.0), (p3, 2.0), "-|>", label: $-1$),
  edge((p2, 1.0), (p3, 3.0), "-|>"),
  edge((p2, 3.0), (p3, 3.0), "-|>", label: $-1$),

  edge((p3, 0.0), (p4, 0.0), "-|>"),
  edge((p3, 1.0), (p4, 1.0), "-|>"),
  edge((p3, 2.0), (p4, 2.0), "-|>", label: $W_4^0$),
  edge((p3, 3.0), (p4, 3.0), "-|>", label: $W_4^1$),

  edge((p4, 0.0), (p5, 0.0), "-|>"),
  edge((p4, 1.0), (p5, 0.0), "-|>"),
  edge((p4, 0.0), (p5, 1.0), "-|>"),
  edge((p4, 1.0), (p5, 1.0), "-|>", label: $-1$),
  edge((p4, 2.0), (p5, 2.0), "-|>"),
  edge((p4, 3.0), (p5, 2.0), "-|>"),
  edge((p4, 2.0), (p5, 3.0), "-|>"),
  edge((p4, 3.0), (p5, 3.0), "-|>", label: $-1$),

  edge((p5, 0.0), (p6, 0.0), "-|>"),
  edge((p5, 1.0), (p6, 1.0), "-|>", label: $W_4^0$),
  edge((p5, 2.0), (p6, 2.0), "-|>"),
  edge((p5, 3.0), (p6, 3.0), "-|>", label: $W_4^0$)
)))


== IFFT

共轭法 $x(n) = (hfrac(1, N)) (FFT{ X^*(k) })^*$

= IIR数字滤波器设计

== 技术指标和设计流程

通带最大衰减$A_p$，阻带最大衰减$A_s$；通带边缘频率$omega_p$，阻带边缘频率$omega_s$；通带波动峰值$delta_p$，阻带波动峰值$delta_s$。

+ 按数字滤波器指标计算模拟滤波器指标
+ 设计设计模拟低通滤波器$H_"LP" (s)$
+ 进行模拟频率变换得到$H_d (s)$
+ 进行模数变换得到数字滤波器$H_d(z)$

== Butterworth 模拟低通滤波器

指标：通带截止频率$Omega_p$，通带最大衰减$A_p$，阻带截止频率$Omega_s$，阻带最大衰减$A_s$

阶数：
$
N=ceil(frac(lg(frac(10^(0.1A_s)-1, 10^(0.1A_p)-1)),2lg(Omega_s/Omega_p)))
$

3 dB 截止频率：
$
  Omega_c = frac(Omega_p, root(2N, 10^(0.1A_p)-1))\
  Omega_c = frac(Omega_s, root(2N, 10^(0.1A_s)-1))
$

归一化频率 $lambda_p=hfrac(Omega_p,Omega_c), lambda_s=hfrac(Omega_s,Omega_c)$

归一化的系统函数多项式表
#figure(text(size: 0.92em, table(
  columns: (auto, 1fr),
  inset: (x: .45em, y: .3em),
  table.header[$N$][$H_N (p)$],
  $1$, $hfrac(1,(p + 1))$,
  $2$, $hfrac(1, (p^2 + sqrt(2) p + 1))$,
  $3$, $hfrac(1,(p + 1)(p^2 + p + 1))$,
)))

反归一化代换 $s=hfrac(p,Omega_c)$

== 模拟滤波器频率变换
指标：通带上下截止频率 $Omega_"p1", Omega_"p2"$，阻带上下截止频率$Omega_"s1", Omega_"s2"$

通带中心频率 $Omega_0 = sqrt(Omega_"p1"Omega_"p2")$

通带带宽 $B = Omega_"p2"-Omega_"p1"$

#figure(text(size: 0.92em, table(
  columns: (auto, 1fr, 1fr),
  inset: (x: .45em, y: .6em),
  table.header[变换类型][原型低通滤波器指标][频率变换函数],
  [低通 $arrow$ 高通], $lambda_p=1,lambda_s=frac(Omega_p, Omega_s)$, $p=frac(Omega_p, s)$,
  [低通 $arrow$ 带通], $lambda_p=1, lambda_s=frac((Omega_"s2" -Omega_"s1"), (Omega_"p2" -Omega_"p1"))$, $p=frac(s^2+ Omega_0^2, B s)$,
  [低通 $arrow$ 带阻], $lambda_p=1, lambda_s=frac((Omega_"p2" -Omega_"p1"), (Omega_"s2" -Omega_"s1"))$,$p=frac(B s, s^2+ Omega_0^2)$
)))

变换得到的模拟带通带阻滤波器都是几何对称的，即
$
Omega_0^2=Omega_"p1"Omega_"p2"=Omega_"s1"Omega_"s2"
$

带通滤波器不对称时需要调大 $Omega_"s1"$ 或者调小 $Omega_"s2"$，使得对称关系满足。$A_s$ 按 $max(A_"s1", A_"s2")$ 计算。

带阻滤波器不对称时需要调大 $Omega_"p1"$ 或者调小 $Omega_"p2"$，使得对称关系满足。$A_p$ 按 $min(A_"p1", A_"p2")$ 计算。

== 模数变换

=== 冲激响应不变法
冲激响应不变准则
$
h(n)=T h_a (n T)
$

一般性的变换式子

$
H(z) = Zee{T dot [(Laplace^(-1)[H_a (s)]) sum_(n=-oo)^(+oo) delta(t- n T)]}
$

对于只有单极点的模拟滤波器
$
  H_a (s) = sum_(i=1)^N frac(A_i, s-s_i)
$

变换为
$
  H(z) = T sum_(i=1)^N frac(A_i, 1-ee^(s_i T)z^(-1))
$

变换关系 $z=ee^(s T)$，但是无法直接用它来进行代换

模拟角频率和数字角频率满足线性关系 $Omega = hfrac(omega,T)$

模拟滤波器限带在 $(-hfrac(Omega_s,2), hfrac(Omega_s,2))$ 即 $(-hfrac(pi,T),hfrac(pi,T))$ 之间时不产生混叠失真，否则产生混叠失真。因此它只适用于低通和带通滤波器设计。

=== Tustin变换法

变换关系

$
s = frac(2, T) frac(1-z^(-1),1+z^(-1))
$

模拟角频率和数字角频率之间满足非线性关系（频率预畸变）

$
Omega = frac(2, T) tan frac(omega, 2)
$

变换前后幅频特性不变，不发生混叠。

= FIR数字滤波器设计

== 线性相位FIR

FIR的频率响应为 $H(ee^(jj omega)) = H(omega)ee^(jj theta(omega))$

$H(omega)$ 是幅度函数，可正可负，$theta(omega)$是相位函数。

严格线性相位指 $theta(omega) = -tau omega$，$tau$ 是常数。

广义线性相位指 $theta(omega) = phi_0 -tau omega$，$phi_0, tau$ 是常数，对于实系数因果FIR来说只存在 $phi_0 = hfrac(pi,2)$的情况。

线性相位FIR的群时延 $tau = hfrac((N-1),2)$

严格线性相位FIR冲激响应偶对称 $h(n)=h(N-1-n)$

广义线性相位FIR冲激响应奇对称 $h(n)=-h(N-1-n)$

如果 $z$ 是线性相位FIR的零点，$z^(-1), z^*, (z^(-1))^*$也是其零点。

I 型：$N$ 为奇数，幅度函数为
$
H(omega)=sum_(n=0)^m a_n cos n omega
$
其中
$
a_n = cases(h(frac(N-1,2)) & quad n=0,2h(frac(N-1,2)-n) & quad n != 0)
$

低通、高通、带通、带阻滤波器都可以直接设计。

II 型：$N$ 为偶数，幅度函数为
$
H(omega)=sum_(n=1)^(hfrac(N,2)) b_n cos[(n-1/2) omega]
$
其中
$
b_n = 2h(frac(N,2)-n)
$
因此必有 $H(pi)=0$。不适合实现低通、高通、带阻滤波器。

III 型：$N$ 为奇数，幅度函数为
$
H(omega)=sum_(n=0)^(hfrac((N-1),2)) c_n sin n omega
$
其中
$
c_n = 2h(frac(N-1,2)-n)
$
因此 $H(0)=H(pi)=0$。不适合实现高通、带阻滤波器。

IV 型：$N$ 为偶数，幅度函数为
$
H(omega)=sum_(n=1)^(hfrac((N-1),2)) d_n sin[(n-1/2) omega]
$
其中
$
d_n = 2h(frac(N,2)-n)
$
因此必有 $H(0)=0$。不适合实现低通、带阻滤波器。

== 窗函数法
吉布斯效应：在理想特性不连续点附近形成过渡带，在通带内产生波动

减小吉布斯效应：主瓣宽度尽可能窄，第一旁瓣相对主瓣尽可能小。

=== 窗函数
矩形窗：$w(n) = 1$

升余弦窗：$w(n) = w_1 - w_2 cos frac(2 pi n, N-1) + w_3 cos frac(4 pi n, N - 1)$

Hanning窗：$w_1=0.5, w_2=0.5, w_3=0$

Hamming窗：$w_1=0.54, w_2=0.46, w_3=0$

Blackman窗：$w_1=0.42, w_2=0.5, w_3=0.08$

Kaiser窗：

$
w(n)=hfrac(I_0 (beta sqrt(1-(1- frac(2n,N-1))^2)),I_0 (beta))
$

Kaiser窗设计经验公式：

$
beta = cases(
  0.1102(A_s-8.7) & quad A_s >50,
  0.5842(A_s-21)^0.4+0.07886(A_s -21) & quad 21 <= A_s <=50,
  0 & quad A_s <21
)\
N=frac(A_s-7.95,2.286 Delta omega)+1
$

=== 设计步骤

+ 选择窗函数：在满足阻带衰减的情况下选择主瓣最窄的窗函数，确定窗口长度 $N = ceil(hfrac("要求的过渡带","滤波器过渡带"))$，按类型选择奇偶
+ 构造 $H_d (ee^(jj omega)) = H_(d a) (omega)ee^(-jj tau omega)$，$tau = hfrac((N-1),2)$
+ 若 $H_d (ee^(jj omega))$ 不是理想滤波器，则截止频率按过渡带中点计算为 $omega_c = hfrac((omega_p + omega_s),2)$  
+ $H_d (ee^(jj omega))$ 反变换得到 $h_d (n)$，加窗逼近得到 $h(n) = h_d (n) dot w(n)$

=== 性能指标对比

#figure(text(size: 0.92em, table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr),
  inset: (x: .45em, y: .6em),
  table.header[窗函数][最大旁瓣峰值\ $alpha_p$/dB][主瓣宽度][过渡带带宽 $Delta omega$][阻带最小衰减/dB],
  [矩形窗],[$-13$],[$hfrac(4pi, N)$],[$hfrac(4pi, N)$],[$-21$],
  [Hanning窗],[$-31$],[$hfrac(8pi, N)$],[$hfrac(6.2pi, N)$],[$-44$],
  [Hamming窗],[$-41$],[$hfrac(8pi, N)$],[$hfrac(6.6pi, N)$],[$-53$],
  [Blackman窗],[$-57$],[$hfrac(12pi, N)$],[$hfrac(11pi, N)$],[$-74$],
  [Kaiser窗\ （$beta=7.865$）],[$-57$],[$hfrac(10pi, N)$],[$hfrac(10pi, N)$],[$-80$],
)))

=== 理想FIR滤波器的单位冲激响应

#figure(text(size: 0.92em, table(
  columns: (auto, 1fr),
  inset: (x: .45em, y: .6em),
  table.header[类型][单位冲激响应],
  [理想低通], $frac(sin(n-tau) omega_c, (n-tau)pi)$,
  [理想高通], $frac(sin(n-tau) pi, (n-tau)pi) - frac(sin(n-tau) omega_c, (n-tau)pi)$,
  [理想带通], $frac(sin(n-tau) omega_h, (n-tau)pi)-frac(sin(n-tau) omega_l, (n-tau)pi)$,
  [理想带阻], $frac(sin(n-tau) omega_l, (n-tau)pi) + frac(sin(n-tau) pi, (n-tau)pi) - frac(sin(n-tau) omega_h, (n-tau)pi)$,
)))

== 频率取样法

+ 对 $H_d (ee^(jj omega))$ 在 $omega = hfrac(2pi k,N)$ 点处进行频域取样得 $H_d (k)$。
+ 对 $H_d (k)$进行 IDTFT 再做Z变换得 $H(z)$。或者由采样值直接进行内插。

= FIR 对比 IIR
- 相同指标下，IIR阶数比FIR低
- IIR有稳定性问题，FIR总是稳定的
- IIR有相位失真，FIR线性相位

= 数字滤波器实现结构

数字滤波器实现结构也就是 $z$ 域上有理函数对应的（实的）信号流图。

== IIR实现结构

=== 直接型
$
H(z) = frac(sum_(i=0)^M a_i z^(-i), 1- sum_(i=1)^N b_i z^(-i))
$

可按差分方程直接实现为直接 I 型：

#figure(text(size: 0.42em, diagram(
  cell-size: 2.1mm,
  node-stroke: .28pt,
  edge-stroke: .35pt,
  node-inset: .08em,

  node((-1.1, 0), [$x(n)$], fill: none, stroke: none),
  node((5.7, 0), [$y(n)$], fill: none, stroke: none),

  node((0, 0), [], radius: .10mm, fill: black, stroke: none),
  node((0, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((0, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((0, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((1.2, 0), [], radius: .10mm, fill: black, stroke: none),
  node((1.2, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((1.2, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((1.2, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((2.7, 0), [], radius: .10mm, fill: black, stroke: none),
  node((2.7, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((2.7, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((2.7, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((3.9, 0), [], radius: .10mm, fill: black, stroke: none),
  node((3.9, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((3.9, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((3.9, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((-0.45, 0.45), [$z^(-1)$], fill: none, stroke: none),
  node((-0.45, 1.35), [$z^(-1)$], fill: none, stroke: none),
  node((-0.45, 2.45), [$z^(-1)$], fill: none, stroke: none),

  node((4.35, 0.45), [$z^(-1)$], fill: none, stroke: none),
  node((4.35, 1.35), [$z^(-1)$], fill: none, stroke: none),
  node((4.35, 2.45), [$z^(-1)$], fill: none, stroke: none),

  node((0.6, 2.3), [$dots.v$], fill: none, stroke: none),
  node((3.3, 2.3), [$dots.v$], fill: none, stroke: none),

  edge((-0.85, 0), (0, 0), "-|>"),
  edge((0, 0), (1.2, 0), "-|>", label: $a_0$),
  edge((1.2, 0), (2.7, 0), "-|>"),
  edge((2.7, 0), (3.9, 0), "-|>"),
  edge((3.9, 0), (5.45, 0), "-|>"),

  edge((0, 0), (0, 0.9), "-|>"),
  edge((0, 0.9), (0, 1.8), "-|>"),
  edge((0, 1.8), (0, 3.0), "-|>"),

  edge((0, 0.9), (1.2, 0.9), "-|>", label: $a_1$),
  edge((0, 1.8), (1.2, 1.8), "-|>", label: $a_2$),
  edge((0, 3.0), (1.2, 3.0), "-|>", label: $a_M$),

  edge((1.2, 3.0), (1.2, 1.8), "-|>"),
  edge((1.2, 1.8), (1.2, 0.9), "-|>"),
  edge((1.2, 0.9), (1.2, 0), "-|>"),

  edge((3.9, 0), (3.9, 0.9), "-|>"),
  edge((3.9, 0.9), (3.9, 1.8), "-|>"),
  edge((3.9, 1.8), (3.9, 3.0), "-|>"),

  edge((3.9, 0.9), (2.7, 0.9), "-|>", label: $b_1$),
  edge((3.9, 1.8), (2.7, 1.8), "-|>", label: $b_2$),
  edge((3.9, 3.0), (2.7, 3.0), "-|>", label: $b_N$),

  edge((2.7, 3.0), (2.7, 1.8), "-|>"),
  edge((2.7, 1.8), (2.7, 0.9), "-|>"),
  edge((2.7, 0.9), (2.7, 0), "-|>"),
)))

调换两块顺序就是直接II型，两块可以共用延时器得到正准 I 型：

#figure(text(size: 0.44em, diagram(
  cell-size: 2.2mm,
  node-stroke: .28pt,
  edge-stroke: .35pt,
  node-inset: .08em,

  node((-1.2, 0), [$x(n)$], fill: none, stroke: none),
  node((4.95, 0), [$y(n)$], fill: none, stroke: none),

  node((0, 0), [], radius: .10mm, fill: black, stroke: none),
  node((0, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((0, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((0, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((1.8, 0), [], radius: .10mm, fill: black, stroke: none),
  node((1.8, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((1.8, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((1.8, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((3.5, 0), [], radius: .10mm, fill: black, stroke: none),
  node((3.5, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((3.5, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((3.5, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((2.12, 0.45), [$z^(-1)$], fill: none, stroke: none),
  node((2.12, 1.35), [$z^(-1)$], fill: none, stroke: none),
  node((2.12, 2.45), [$z^(-1)$], fill: none, stroke: none),

  node((0.88, 2.3), [$dots.v$], fill: none, stroke: none),
  node((2.6, 2.3), [$dots.v$], fill: none, stroke: none),

  edge((-0.95, 0), (0, 0), "-|>"),
  edge((0, 0), (1.8, 0), "-|>"),
  edge((1.8, 0), (3.5, 0), "-|>", label: $a_0$),
  edge((3.5, 0), (4.7, 0), "-|>"),

  edge((0, 3.0), (0, 1.8), "-|>"),
  edge((0, 1.8), (0, 0.9), "-|>"),
  edge((0, 0.9), (0, 0), "-|>"),

  edge((1.8, 0), (1.8, 0.9), "-|>"),
  edge((1.8, 0.9), (1.8, 1.8), "-|>"),
  edge((1.8, 1.8), (1.8, 3.0), "-|>"),

  edge((3.5, 3.0), (3.5, 1.8), "-|>"),
  edge((3.5, 1.8), (3.5, 0.9), "-|>"),
  edge((3.5, 0.9), (3.5, 0), "-|>"),

  edge((1.8, 0.9), (0, 0.9), "-|>", label: $b_1$),
  edge((1.8, 1.8), (0, 1.8), "-|>", label: $b_2$),
  edge((1.8, 3.0), (0, 3.0), "-|>", label: $b_N$),

  edge((1.8, 0.9), (3.5, 0.9), "-|>", label: $a_1$),
  edge((1.8, 1.8), (3.5, 1.8), "-|>", label: $a_2$),
  edge((1.8, 3.0), (3.5, 3.0), "-|>", label: $a_M$),
)))

正准I型可以通过流图转置得到正准II型。

#figure(text(size: 0.44em, diagram(
  cell-size: 2.2mm,
  node-stroke: .28pt,
  edge-stroke: .35pt,
  node-inset: .08em,

  node((-1.2, 0), [$x(n)$], fill: none, stroke: none),
  node((4.95, 0), [$y(n)$], fill: none, stroke: none),

  node((0, 0), [], radius: .10mm, fill: black, stroke: none),
  node((0, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((0, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((0, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((1.8, 0), [], radius: .10mm, fill: black, stroke: none),
  node((1.8, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((1.8, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((1.8, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((3.5, 0), [], radius: .10mm, fill: black, stroke: none),
  node((3.5, 0.9), [], radius: .10mm, fill: black, stroke: none),
  node((3.5, 1.8), [], radius: .10mm, fill: black, stroke: none),
  node((3.5, 3.0), [], radius: .10mm, fill: black, stroke: none),

  node((2.12, 0.45), [$z^(-1)$], fill: none, stroke: none),
  node((2.12, 1.35), [$z^(-1)$], fill: none, stroke: none),
  node((2.12, 2.45), [$z^(-1)$], fill: none, stroke: none),

  node((0.88, 2.3), [$dots.v$], fill: none, stroke: none),
  node((2.6, 2.3), [$dots.v$], fill: none, stroke: none),

  edge((-0.95, 0), (0, 0), "-|>"),
  edge((0, 0), (1.8, 0), "-|>", label: $a_0$),
  edge((1.8, 0), (3.5, 0), "-|>"),
  edge((3.5, 0), (4.7, 0), "-|>"),

  edge((0, 3.0), (0, 1.8), "<|-"),
  edge((0, 1.8), (0, 0.9), "<|-"),
  edge((0, 0.9), (0, 0), "<|-"),

  edge((1.8, 0), (1.8, 0.9), "<|-"),
  edge((1.8, 0.9), (1.8, 1.8), "<|-"),
  edge((1.8, 1.8), (1.8, 3.0), "<|-"),

  edge((3.5, 3.0), (3.5, 1.8), "<|-"),
  edge((3.5, 1.8), (3.5, 0.9), "<|-"),
  edge((3.5, 0.9), (3.5, 0), "<|-"),

  edge((1.8, 0.9), (0, 0.9), "<|-", label: $a_1$),
  edge((1.8, 1.8), (0, 1.8), "<|-", label: $a_2$),
  edge((1.8, 3.0), (0, 3.0), "<|-", label: $a_M$),

  edge((1.8, 0.9), (3.5, 0.9), "<|-", label: $b_1$),
  edge((1.8, 1.8), (3.5, 1.8), "<|-", label: $b_2$),
  edge((1.8, 3.0), (3.5, 3.0), "<|-", label: $b_N$),
)))

=== 级联型

将 $H(z)$ 因式分解为

$
A frac(product_i (1-q_i z^(-1)) product_i (1+alpha_(1i) z^(-1)+alpha_(2i) z^(-2))
,
product_i (1-p_i z^(-1)) product_i (1+beta_(1i) z^(-1)+beta_(2i) z^(-2))
)
$

凑成二阶基本节为

$
A product_i frac(1+alpha_(1i) z^(-1)+alpha_(2i) z^(-2), 1+beta_(1i) z^(-1)+beta_(2i) z^(-2))
$

每个基本节用正准型实现。

=== 并联型

将 $H(z)$ 部分分式分解，并合并共轭极点为二次式。子系统分别按正准型实现后并联。

== FIR实现结构

=== 直接型

对于 $H(z) = sum_(n=0)^(N-1) h(n)z^(-n)$，可以直接实现：

#figure(text(size: 0.44em, diagram(
  cell-size: 2.2mm,
  node-stroke: .28pt,
  edge-stroke: .35pt,
  node-inset: .08em,

  node((-1.0, 1.1), [$x(n)$], fill: none, stroke: none),
  node((5.6, 0), [$y(n)$], fill: none, stroke: none),

  node((0, 1.1), [], radius: .10mm, fill: black, stroke: none),
  node((1.0, 1.1), [], radius: .10mm, fill: black, stroke: none),
  node((2.0, 1.1), [], radius: .10mm, fill: black, stroke: none),
  node((3.5, 1.1), [], radius: .10mm, fill: black, stroke: none),
  node((4.7, 1.1), [], radius: .10mm, fill: black, stroke: none),

  node((0, 0), [], radius: .10mm, fill: black, stroke: none),
  node((1.0, 0), [], radius: .10mm, fill: black, stroke: none),
  node((2.0, 0), [], radius: .10mm, fill: black, stroke: none),
  node((3.5, 0), [], radius: .10mm, fill: black, stroke: none),
  node((4.7, 0), [], radius: .10mm, fill: black, stroke: none),

  node((0.5, 1.55), [$z^(-1)$], fill: none, stroke: none),
  node((1.5, 1.55), [$z^(-1)$], fill: none, stroke: none),
  node((2.75, 1.55), [$z^(-1)$], fill: none, stroke: none),
  node((4.1, 1.55), [$z^(-1)$], fill: none, stroke: none),

  node((3.35, 0.45), [$dots.c$], fill: none, stroke: none),

  edge((-0.75, 1.1), (0, 1.1), "-|>"),
  edge((0, 1.1), (1.0, 1.1), "-|>"),
  edge((1.0, 1.1), (2.0, 1.1), "-|>"),
  edge((2.0, 1.1), (3.5, 1.1), "-|>"),
  edge((3.5, 1.1), (4.7, 1.1), "-|>"),

  edge((0, 1.1), (0, 0), "-|>", label: $h(0)$),
  edge((1.0, 1.1), (1.0, 0), "-|>", label: $h(1)$),
  edge((2.0, 1.1), (2.0, 0), "-|>", label: $h(2)$),
  edge((4.7, 1.1), (4.7, 0), "-|>", label: $h(N-1)$),

  edge((0, 0), (1.0, 0), "-|>"),
  edge((1.0, 0), (2.0, 0), "-|>"),
  edge((2.0, 0), (3.5, 0), "-|>"),
  edge((3.5, 0), (4.7, 0), "-|>"),
  edge((4.7, 0), (5.35, 0), "-|>"),
)))

=== 级联型

将 $H(z)$ 因式分解为 $product_i (alpha_(0i) + alpha_(1i)z^(-1) + alpha_(2i) z^(-2))$。 分别实现二阶基本节后级联。

=== 线性相位结构

实现线性相位 FIR可以利用冲激响应的对称性。

第I型可以实现如下，第III型只需要酌情添加 $-1$。

#figure(text(size: 0.35em, diagram(
  cell-size: 2.0mm,
  node-stroke: none,
  edge-stroke: .35pt,
  node-inset: .08em,

  // 输入与输出文本标注
  node((-0.6, 0.0), [$x(n)$]),
  node((-0.6, 2.0), [$y(n)$]),

  // 顶层横向信号流 (输入延时链) - 已分离 z^(-1)
  edge((0.0, 0.0), (1.6, 0.0)),
  edge((1.6, 0.0), (3.2, 0.0), "-|>"),
  edge((3.2, 0.0), (4.8, 0.0), "-|>"),
  edge((4.8, 0.0), (5.4, 0.0), "-|>"),
  node((5.7, 0.0), [$dots.c$]),
  edge((6.0, 0.0), (7.2, 0.0)),
  edge((7.2, 0.0), (9.2, 0.0), "-|>"),

  // 顶层独立的 z^(-1) 节点 (处于各段延时链的中点上方)
  node((2.2, -0.4), [$z^(-1)$]),
  node((3.8, -0.4), [$z^(-1)$]),
  node((8.2, -0.4), [$z^(-1)$]),

  // 中层横向信号流 (对称反馈延时链) - 已分离 z^(-1)
  edge((7.2, 1.0), (9.2, 1.0), "<|-"),
  edge((6.0, 1.0), (7.2, 1.0)),
  node((5.7, 1.0), [$dots.c$]),
  edge((4.8, 1.0), (5.4, 1.0), "<|-"),
  edge((3.2, 1.0), (4.8, 1.0), "<|-"),
  edge((1.6, 1.0), (3.2, 1.0), "<|-"),

  // 中层独立的 z^(-1) 节点 (处于各段延时链的中点上方)
  node((2.2, 0.6), [$z^(-1)$]),
  node((3.8, 0.6), [$z^(-1)$]),
  node((8.2, 0.6), [$z^(-1)$]),


  // 底层横向信号流 (累加链)
  edge((0.0, 2.0), (1.0, 2.0), "<|-"),
  edge((1.0, 2.0), (2.6, 2.0), "<|-"),
  edge((2.6, 2.0), (4.2, 2.0), "<|-"),
  edge((4.2, 2.0), (6.6, 2.0), "<|-"),
  edge((6.6, 2.0), (9.2, 2.0), "<|-"),

  // 第一级折线分支
  edge((1.6, 0.0), (1.0, 0.5), "-|>"),
  edge((1.6, 1.0), (1.0, 0.5), "-|>"),
  edge((1.0, 0.5), (1.0, 2.0), "-|>"),
  node((1.6, 1.5), [$h(0)$]), // 独立系数节点

  // 第二级折线分支
  edge((3.2, 0.0), (2.6, 0.5), "-|>"),
  edge((3.2, 1.0), (2.6, 0.5), "-|>"),
  edge((2.6, 0.5), (2.6, 2.0), "-|>"),
  node((3.2, 1.5), [$h(1)$]), // 独立系数节点

  // 第三级折线分支
  edge((4.8, 0.0), (4.2, 0.5), "-|>"),
  edge((4.8, 1.0), (4.2, 0.5), "-|>"),
  edge((4.2, 0.5), (4.2, 2.0), "-|>"),
  node((4.8, 1.5), [$h(2)$]), // 独立系数节点

  // 倒数第二级折线分支
  edge((7.2, 0.0), (6.6, 0.5), "-|>"),
  edge((7.2, 1.0), (6.6, 0.5), "-|>"),
  edge((6.6, 0.5), (6.6, 2.0), "-|>"),
  node((7.5, 1.5), [$h(frac(N-3, 2))$]), // 独立分式节点，水平居中于宽间距中

  // 最右侧直通分支
  edge((9.2, 0.0), (9.2, 1.0), "-|>"),
  edge((9.2, 1.0), (9.2, 2.0), "-|>"),
  node((9.9, 1.5), [$h(frac(N-1, 2))$]) // 独立分式节点，放置于右侧外部
)))

第II型可以实现如下，第IV型只需要酌情添加 $-1$。

#figure(text(size: 0.35em, diagram(
  cell-size: 2.0mm,
  node-stroke: none,
  edge-stroke: .35pt,
  node-inset: .08em,

  // 输入与输出文本标注
  node((-0.6, 0.0), [$x(n)$]),
  node((-0.6, 2.0), [$y(n)$]),

  // 顶层横向信号流 (输入延时链)
  edge((0.0, 0.0), (1.6, 0.0)),
  edge((1.6, 0.0), (3.2, 0.0), "-|>"),
  edge((3.2, 0.0), (4.8, 0.0), "-|>"),
  edge((4.8, 0.0), (5.4, 0.0), "-|>"),
  node((5.7, 0.0), [$dots.c$]),
  edge((6.0, 0.0), (7.2, 0.0)),
  edge((7.2, 0.0), (9.2, 0.0), "-|>"),

  // 顶层独立的 z^(-1) 节点
  node((2.2, -0.4), [$z^(-1)$]),
  node((3.8, -0.4), [$z^(-1)$]),
  node((8.2, -0.4), [$z^(-1)$]),

  // 中层横向信号流 (对称反馈延时链)
  edge((7.2, 1.0), (9.2, 1.0), "<|-"),
  edge((6.0, 1.0), (7.2, 1.0)),
  node((5.7, 1.0), [$dots.c$]),
  edge((4.8, 1.0), (5.4, 1.0), "<|-"),
  edge((3.2, 1.0), (4.8, 1.0), "<|-"),
  edge((1.6, 1.0), (3.2, 1.0), "<|-"),

  // 中层独立的 z^(-1) 节点
  node((2.2, 0.6), [$z^(-1)$]),
  node((3.8, 0.6), [$z^(-1)$]),
  node((8.2, 0.6), [$z^(-1)$]),

  // 底层横向信号流 (累加链 - 结束于 8.6)
  edge((0.0, 2.0), (1.0, 2.0), "<|-"),
  edge((1.0, 2.0), (2.6, 2.0), "<|-"),
  edge((2.6, 2.0), (4.2, 2.0), "<|-"),
  edge((4.2, 2.0), (6.6, 2.0), "<|-"),
  edge((6.6, 2.0), (8.6, 2.0), "<|-"),

  // 第一级折线分支及独立系数
  edge((1.6, 0.0), (1.0, 0.5), "-|>"),
  edge((1.6, 1.0), (1.0, 0.5), "-|>"),
  edge((1.0, 0.5), (1.0, 2.0), "-|>"),
  node((1.6, 1.5), [$h(0)$]),

  // 第二级折线分支及独立系数
  edge((3.2, 0.0), (2.6, 0.5), "-|>"),
  edge((3.2, 1.0), (2.6, 0.5), "-|>"),
  edge((2.6, 0.5), (2.6, 2.0), "-|>"),
  node((3.2, 1.5), [$h(1)$]),

  // 第三级折线分支及独立系数
  edge((4.8, 0.0), (4.2, 0.5), "-|>"),
  edge((4.8, 1.0), (4.2, 0.5), "-|>"),
  edge((4.2, 0.5), (4.2, 2.0), "-|>"),
  node((4.8, 1.5), [$h(2)$]),

  // 倒数第二级折线分支及独立系数 (h(N/2 - 2))
  edge((7.2, 0.0), (6.6, 0.5), "-|>"),
  edge((7.2, 1.0), (6.6, 0.5), "-|>"),
  edge((6.6, 0.5), (6.6, 2.0), "-|>"),
  node((7.4, 1.5), [$h(frac(N, 2) - 2)$]),

  // 最后一级折线分支及独立系数 (h(N/2 - 1))
  edge((9.2, 0.0), (8.6, 0.5), "-|>"),
  edge((9.2, 1.0), (8.6, 0.5), "-|>"),
  edge((8.6, 0.5), (8.6, 2.0), "-|>"),
  node((9.4, 1.5), [$h(frac(N, 2) - 1)$]),

  // 右侧垂直边界线与独立的垂直 z^(-1) 节点
  edge((9.2, 0.0), (9.2, 1.0), "-|>"),
  node((9.6, 0.5), [$z^(-1)$])
)))
=== 频率取样结构
通过z域内插得到
$
H(z) = frac(1-z^(-N), N) sum_(k=0)^(N-1)frac(H_d (k), 1-W_N^(-k)z^(-1))
$

分别实现然后并联，级联。由于精度问题，可能导致系统不稳定。此时用 $r z^(-1)$ 代替 $z^(-1)$，其中 $r < 1, r approx 1$。$h(n)$ 为实序列时，可以将对称项合并为二阶网络来实现。

$N$为偶数时：
$
H(z) = frac((1-r^N z^(-N)),N) dot\  [frac(H_d (0),1-r z^(-1)) + frac(H_d (frac(N,2)),1+r z^(-1)) + sum_(k=1)^(frac(N,2)-1) frac(b_(0k)+b_(1k)z^(-1),1-2r cos(frac(2pi,N)k)z^(-1) +r^2z^(-2)) ]
$

$N$为奇数时：
$
H(z) = frac((1-r^N z^(-N)),N) dot [frac(H_d (0),1-r z^(-1))  + sum_(k=1)^(frac(N-1,2)) frac(b_(0k)+b_(1k)z^(-1),1-2r cos(frac(2pi,N)k)z^(-1) +r^2z^(-2)) ]
$

其中 $b_(0k) =2Re [H_d (k)], b_(1k)=-2Re [r H_d (k) W_N^k]$
