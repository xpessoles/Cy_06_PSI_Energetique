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
om = []
C = []
P = []
for t in temps :
    if t<=t1:
        v.append(t*amax)
        a.append(amax)
        C.append(pv/(2*math.pi) * (Meq*amax+M*g))
        om.append(v[-1]*2*math.pi/pv)
        P.append(om[-1]*C[-1])
    elif t<=t2 :
        v.append(vr)
        a.append(0)
        C.append(pv/(2*math.pi) * (Meq*0+M*g))
        om.append(v[-1]*2*math.pi/pv)
        P.append(om[-1]*C[-1])
    else :
        # v(t)=-ax+b
        # v(t3)=0 >> a*t3 = b
        v.append(-amax*t+amax*t3)
        a.append(-amax)
        C.append(pv/(2*math.pi) * (-Meq*amax+M*g))
        om.append(v[-1]*2*math.pi/pv)
        P.append(om[-1]*C[-1])

P0 = max(om)*max(C)
print(P0," W")
print(P0/0.3," W")

#plt.plot(temps,v)
#plt.plot(temps,a)
plt.plot(temps,P)
#plt.plot(temps,om)
#plt.show()


# Avec contrepoids
omax = max(om)
Meq = (Jr+Jv)*((2*math.pi)/(pv))**2+2*M

print("Meq ",Meq)
C_cp = pv/(2*math.pi) * (Meq*amax)
print(C_cp)

k = 0.1*M*g/0.8

d = 9.7e-4*(M*g*1.1)**(1/3)
n  = (10**13)*d**4/k

#Vérin a azote
C = (pv/2/math.pi)*(547*amax-M*g+1300)

