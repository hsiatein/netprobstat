#align(center)[
  #text(size: 32pt)[网络数据的概率与统计方法]
  #v(0cm)
  #text(size: 32pt)[Homework 3]
  #v(2cm)
  #text(size: 18pt)[夏添]
]

#pagebreak()

= 5.1

$ hat(tau)_pi=sum_(i in S) y_i/pi_i=sum_(i in scr(U)) (y_i Z_i)/pi_i $

$ VV(hat(tau)_pi)=sum_(i in scr(U)) sum_(j in scr(U)) y_i y_j ((pi_(i j))/(pi_i pi_j)-1) $

$ hat(VV)(hat(tau)_pi)&=sum_(i in S) sum_(j in S) y_i y_j (1/(pi_i pi_j)-1/pi_(i j))
\
&=sum_(i in scr(U)) sum_(j in scr(U)) y_i y_j Z_i Z_j (1/(pi_i pi_j)-1/pi_(i j)) $

$ EE(hat(VV)(hat(tau)_pi))&=EE(sum_(i in scr(U)) sum_(j in scr(U)) y_i y_j Z_i Z_j (1/(pi_i pi_j)-1/pi_(i j)))
\
&=sum_(i in scr(U)) sum_(j in scr(U)) y_i y_j EE(Z_i Z_j) (1/(pi_i pi_j)-1/pi_(i j))
\
&=sum_(i in scr(U)) sum_(j in scr(U)) y_i y_j pi_(i j) (1/(pi_i pi_j)-1/pi_(i j))
\
&=VV(hat(tau)_pi) $

= 5.2

== 5.2.a

选择n个的总可能数为$binom(N_V-1,n)$, i,j固定, 剩余$N_V-3$个选择$n-2$个可能数为$binom(N_V-3,n-2)$
$ pi_(i j)&=binom(N_V-3,n-2)/binom(N_V-1,n)
\
&=((N_V-3)!(N_V-n-1)!n!)/((n-2)!(N_V-1)!(N_V-n-1)!)
\
&=(n(n-1))/((N_V-1)(N_V-2)) $

== 5.2.b

程序5.2.b.jl随机选择十个节点进行估计, 如下表格列分别为节点索引, 度, 介数中心性, 真值, 估计值
#table(
  columns: 5,
  align: (center, center, center, center, center),
  [k], [deg], [bc], [true], [mean],
  [4], [18], [0.3793], [154], [154.0],
  [29], [3], [0.0074], [3], [3.2],
  [20], [3], [0.0000], [0], [0.0],
  [21], [5], [0.0172], [7], [7.2],
  [16], [4], [0.0172], [7], [7.4],
  [9], [9], [0.0591], [24], [25.0],
  [24], [4], [0.0074], [3], [2.8],
  [14], [4], [0.0025], [1], [1.0],
  [3], [8], [0.0813], [33], [32.2],
  [23], [3], [0.0049], [2], [2.2],
)
