#align(center)[
  #text(size: 32pt)[网络数据的概率与统计方法]
  #v(0cm)
  #text(size: 32pt)[Homework 4]
  #v(2cm)
  #text(size: 18pt)[夏添]
]

#pagebreak()

= 6.1

== 6.1.a

对于$EE(N)$, 很明显其为伯努利采样的期望, 因此有$EE(N)=N_v p_0$.

对于$EE(M_1)$, 首先其为有向图, 共$N_v (N_v-1)$条边, 每条边的两个顶点都在$V_0$里面, 采样概率为$p_0^2$, 边自身的采样概率为$p_scr(G)$.因此$EE(M_1)=N_v (N_v-1)p_0^2 p_scr(G)$.

对于$EE(M_2)$, 每条边一个顶点在$V_0$里面一个在$V_0$外面, 采样概率为$p_0 (1-p_0)$, 边自身的采样概率为$p_scr(G)$.因此$EE(M_2)=N_v (N_v-1)p_0 (1-p_0) p_scr(G)$.

== 6.1.b

经过简单计算可以发现
$ EE(M_1)+EE(M_2)=N_v (N_v-1)p_0 p_scr(G) $
$ EE(M_1)/(EE(M_1)+EE(M_2))=p_0 $
$ (EE(N)(EE(M_1)+EE(M_2)))/EE(M_1)=N_v $
$ (EE(M_1)+EE(M_2))/(EE(N) ((EE(N)(EE(M_1)+EE(M_2)))/EE(M_1)-1))=p_scr(G) $
代入估计值可以发现
$ hat(p_0)=m_1 /(m_1 +m_2) $
$ hat(N_v)=n(m_1 +m_2)/(m_1) $
$ hat(p_scr(G))=(m_1(m_1 +m_2))/(n ((n-1)m_1+n m_2)) $

= 6.2

== 6.2.a

$t$时刻度为$2 m t$, 节点数为$t$, 新连接$m$条边, 流向度为$d$的节点的平均数量为
$ m times d/(2 m t) times t f_d (t)=(d f_d (t))/2 $
因此考虑变化量为新增的度$d$节点数量减去失去的度$d$节点数量
$ n_d (t+1)-n_d (t) = ((d-1) f_(d-1) (t))/2-(d f_d (t))/2 $
$ (t+1) f_d (t+1)=t f_d (t) + ((d-1) f_(d-1) (t))/2-(d f_d (t))/2 $
