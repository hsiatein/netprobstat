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