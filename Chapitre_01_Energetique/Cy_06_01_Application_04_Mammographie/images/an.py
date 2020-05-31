import math
import numpy as np
import matplotlib.pyplot as plt
pv = 6e-3
Jr = 2.6e-4
Jv = 1.2e-4
M = 130
ta = 0.4
vr = 0.15
amax = vr/ta
g = 9.81


Meq = (Jr+Jv)*((2*math.pi)/(pv))**2+M

print("Meq ",Meq)

C = (pv/(2*math.pi))*(Meq*amax + M*g)

print("C ",C)

t1 = ta
t2 = ta+4.13
t3 = t2+ta

# Vitesse
temps = np.linspace(0,t3,1000)
v=[]
a=[]
C = []
for t in temps :
    if t<=t1:
        v.append(t*amax)
        a.append(amax)
        C.append(pv/(2*math.pi) * (Meq*amax+M*g))
    elif t<=t2 :
        v.append(vr)
        a.append(0)
        C.append(pv/(2*math.pi) * (Meq*0+M*g))
    else :
        # v(t)=-ax+b
        # v(t3)=0 >> a*t3 = b
        v.append(-amax*t+amax*t3)
        a.append(-amax)
        C.append(pv/(2*math.pi) * (-Meq*amax+M*g))

#plt.plot(temps,v)
#plt.plot(temps,a)
plt.plot(temps,C)
plt.show()


