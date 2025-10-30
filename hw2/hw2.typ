#align(center)[
  #text(size: 32pt)[网络数据的概率与统计方法]
  #v(0cm)
  #text(size: 32pt)[Homework 2]
  #v(2cm)
  #text(size: 18pt)[夏添]
]

#pagebreak()

= 4.1

== 4.1.a

#align(center)[
  $ l(alpha) &= sum_(i=1)^n log alpha +alpha log x_0 - (alpha +1)log x_i
  \
  l'(alpha) &= n/alpha - sum_(i=1)^n log x_i/x_0=0
  \
  alpha &= n/(sum_(i=1)^n log x_i/x_0) $
]

== 4.1.b

计算程序见4.1.b.jl
#table(
  columns: 7,
  align: center,
  stroke: 0.5pt + gray,
  table.header(
    [$alpha_"true"$], [n], [estimator], [$alpha_"est"$], [bias], [rmse], [sd]
  ),
  [1.2], [50], [Hill], [1.22592], [0.025925], [0.173648], [0.171788],
  [1.2], [50], [4.2], [1.10529], [-0.0947127], [0.239506], [0.220094],
  [1.2], [50], [4.3], [-1.60516], [-2.80516], [2.81648], [0.252422],
  [1.2], [200], [Hill], [1.20472], [0.00471786], [0.0832323], [0.08314],
  [1.2], [200], [4.2], [1.15016], [-0.0498397], [0.126535], [0.116365],
  [1.2], [200], [4.3], [-1.73563], [-2.93563], [2.93853], [0.130606],
  [2.0], [50], [Hill], [2.0288], [0.0287994], [0.291825], [0.290546],
  [2.0], [50], [4.2], [1.8292], [-0.170804], [0.396492], [0.357995],
  [2.0], [50], [4.3], [-2.65361], [-4.65361], [4.67227], [0.417347],
  [2.0], [200], [Hill], [2.01421], [0.0142107], [0.142586], [0.141947],
  [2.0], [200], [4.2], [1.92309], [-0.0769104], [0.208302], [0.19368],
  [2.0], [200], [4.3], [-2.90635], [-4.90635], [4.91132], [0.220891],
)

= 4.2

== 4.2.a

只证明$delta_(s+) (v)= display(sum_(z:v in P_s (z))) sigma(s,v)/sigma(s,z) (1+delta_(s+) (z))$, 因为4.2.a的情况下$sigma(s,v)=sigma(s,z)=1$, 显然可以从4.2.b推出.

== 4.2.b



$sigma(s,t|v)$是从s到t的最短路径需要经过v的数量, 因此
#set math.equation(numbering: "(1)")
$ sigma(s,t|v)=sigma(s,v)sigma(v,t), $
#set math.equation(numbering: none)
其含义是从s到t的经过v的最短路径可以分解为v前半段与v后半段的最短路径数量乘积. 因此考虑$sigma(s,t|v)/sigma(s,v)=sigma(v,t)$, 由于$sigma(v,t)$可以分割为$display(sum_(z:v in P_s (z))) sigma(z,t)$, 其实就是把路径数量按照v的第一个后继来分组, 代入(1)式得到

$ sigma(s,t|v)/sigma(s,v)&=display(sum_(z:v in P_s (z))) sigma(s,t|z)/sigma(s,z),
\
sigma(s,t|v)&=display(sum_(z:v in P_s (z))) sigma(s,v)/sigma(s,z)sigma(s,t|z),
\
sigma(s,t|v)/sigma(s,t)&=display(sum_(z:v in P_s (z))) sigma(s,v)/sigma(s,z)sigma(s,t|z)/sigma(s,t),
\
delta_(s t) (v)&=display(sum_(z:v in P_s (z))) sigma(s,v)/sigma(s,z) delta_(s t) (z),
\
display(sum_(t in V))delta_(s t) (v)&=display(sum_(t in V))display(sum_(z:v in P_s (z))) sigma(s,v)/sigma(s,z) delta_(s t) (z),
\
&=display(sum_(z:v in P_s (z))) sigma(s,v)/sigma(s,z) display(sum_(t in V))delta_(s t) (z),
\
delta_(s+) (v)&= display(sum_(z:v in P_s (z))) sigma(s,v)/sigma(s,z) (1+delta_(s+) (z)), $
证毕.

= 4.3

== 4.3.a

$ &quad (sum_(v in V') tau_3 (v) "cl"(v))/(sum_(v in V') tau_3 (v))
\
&=(sum_(v in V') tau_triangle (v))/(sum_(v in V') tau_3 (v))
\
&=(3 tau_triangle (G))/(tau_3 (G)) $

== 4.3.b

考虑一类由n个三角形组成的图$G_n$, 那些三角形共享同一个顶点, 但是剩余的两个顶点以及边不和其他三角形重合, 也就是说图里有2n+1个顶点和n个三角形, 中心顶点度为2n, 其余顶点度为2, 因此可以计算出外围顶点$"cl"(v)=1$, 中心顶点$"cl"(v)=1/(2n-1)$, 
$ "cl"(G_n)=(2n+1/(2n-1))/(2n+1)->1 $
$ "cl"_"T" (G_n)=(3n)/(binom(2n,2)+2n binom(2,2))->0 $

