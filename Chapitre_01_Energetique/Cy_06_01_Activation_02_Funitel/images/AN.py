import math as m
L  = 1669
mu = 8.47
Mc = 2500
Mp = 2080
IM = 575000
Dp = 4
N = 1700
g = 9.81
#omega = N*2*m.pi/60
print("omega",omega)
V= 7.2

Meq = 4*L*mu + 16*Mc + 8*Mp + IM*4/(Dp*Dp)
print(Meq)

ec = 0.5*Meq*V*V
print(V)
print(ec/1000000)

ppes=-8*Mp*g*V*m.sin(m.radians(17.8))
print(ppes)

Ve = 30
rho = 1.3
Sf = 7.1

pvent = -16*rho*Sf*Ve*V*V
print(pvent)

