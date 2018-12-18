## Import des librairies

from math import pi
from math import cos
import matplotlib.pyplot as plt
from numpy import sign

## Définition des fonctions

def f_Affiche_liste(fig_i,Liste_X,Liste_Y,Legende):
    fig = plt.figure(fig_i)
    plt.plot(Liste_X,Liste_Y,"--",label=Legende)
    plt.ylabel('Données')
    plt.legend()
    plt.show()

## Définition des variables

A = 26.0222
B = 25.1627

a = 2.565
b = 0.2565
c = 1.977963099

Teta_0_rd = 1.73298
k = -23.5234

dt = 0.01

Cfs = 0.26
Cfv = 0.451

## Fonction de test d'arrêt de la lisse

def Signe(x):
    if sign(x) >= 0:
        return 1
    else:
        return -1

def Arret(Vect): # Détecte 2 changements de pente successifs en renvoyant 3
    Delta_1 = Vect[1]-Vect[0]
    Delta_2 = Vect[2]-Vect[1]
    Delta_3 = Vect[3]-Vect[2]
    Evol_1 = Signe(Delta_1)
    Evol_2 = Signe(Delta_2)
    Evol_3 = Signe(Delta_3)
    Cond = abs(Evol_1 - Evol_2 + Evol_3)
    return Cond

## Fonction de résolution

def Resolution(X,Teta_0_rd,Fig,Cas):
    J = a*X**2 + b*X + c
    Teta = [0]
    Vitesse = [0]
    Temps = [0]
    Liste_C_Tot = []
    Liste_C_Pes = []
    Liste_C_Res = []
    Liste_C_Fs = []
    Liste_C_Fv = []
    Tps = 0
    i = 0
    Cond = 0
    while Temps[i] < 10 and Teta[i] < pi/2 and Cond != 3:
        # Incrémentation temps
        i += 1
        Tps = Temps[i-1]
        Tps += dt
        Temps.append(Tps)
        # Cas particulier du premier pas de temps
        Teta_Act = Teta[i-1]
        if i == 1:
            Teta_Prec = 0
            Signe_V = 0
            Vit = 0
        else:
            Teta_Prec = Teta[i-2]
            Signe_V = sign(Teta_Act - Teta_Prec)
            Vit = (Teta_Act - Teta_Prec)/dt
        # Calcul des couples sur la lisse
        C_Pes = - (A + B * X) * cos(Teta_Act)
        C_Res = k * (Teta_Act - Teta_0_rd)
        C_Fs = - Signe_V * Cfs
        C_Fv = - Cfv * Vit
        Somme_C = C_Res + C_Pes + C_Fs + C_Fv
        # Stockage des couples pour éventuel affichage
        Liste_C_Tot.append(Somme_C)
        Liste_C_Pes.append(C_Pes)
        Liste_C_Res.append(C_Res)
        Liste_C_Fs.append(C_Fs)
        Liste_C_Fv.append(C_Fv)
        # Calcul de la prochaine position
        Acc = Somme_C / J
        Teta_Suiv = Acc*dt**2 + 2*Teta_Act - Teta_Prec
        Teta.append(Teta_Suiv)
        Vitesse.append(Vit)
        if i >= 2: # Test d'arrêt de la lisse
            Vect = [Teta[i-3],Teta[i-2],Teta[i-1],Teta[i]]
            Cond = Arret(Vect)
    # Stockage de l'angle
    Teta_Deg = [Teta[i]*180/pi for i in range(len(Teta))]
    if Cas == 0: # Variation de la position x
        Legende = str(X)
    elif Cas == 1: # Variation du calage angulaire
        Teta_0_dg = Teta_0_rd * 180 / pi
        Legende = str(round(Teta_0_dg,3))
    # Affichage
    f_Affiche_liste(10*Fig,Temps,Teta_Deg,Legende)
    # f_Affiche_liste(10*(Fig+1),Temps,Vitesse,Legende)
    # f_Affiche_liste(10*(Fig+2),Temps[1:len(Temps)],Liste_C_Tot,Legende)
    # f_Affiche_liste(10*(Fig+2),Temps[1:len(Temps)],Liste_C_Pes,Legende)
    # f_Affiche_liste(10*(Fig+2),Temps[1:len(Temps)],Liste_C_Res,Legende)
    # f_Affiche_liste(10*(Fig+2),Temps[1:len(Temps)],Liste_C_Fs,Legende)
    # f_Affiche_liste(10*(Fig+2),Temps[1:len(Temps)],Liste_C_Fv,Legende)
    # Valeur d'angle en fin de simu
    Teta_Fin = Teta_Deg[len(Teta_Deg)-1]
    return Teta_Fin,Tps

# Fermeture des fenêtres

plt.close("all")

# Résolution pour différentes valeurs de X

L = [0.105,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55]
for x in L:
    Resolution(x,Teta_0_rd,1.1,0)

# Détermination du calage initial

Teta_0_dg = Teta_0_rd * 180 / pi
Teta_Deg = Teta_0_dg
Teta_Fin = 0
Temps_Fin = 9999
x = 0.55
dteta = 0.2 # Degrés
while Teta_Fin < 90 or Temps_Fin > 3: # Mettre and pour avoir le temps à partir duquel ça monte
    Teta_Deg += dteta
    Teta_0_rd = Teta_Deg * pi / 180
    Teta_Fin,Temps_Fin = Resolution(x,Teta_0_rd,1.2,1)

Calage_rad = Teta_0_rd
Calage_Deg = Calage_rad * 180 / pi
Calage_Deg = Calage_Deg - dteta/2
Calage_Deg = round(Calage_Deg,2)
print("")
print("")
print("Calage final: ",Calage_Deg," ° +- ", dteta/2)
print("")
print("")

# Barrière pour ce nouveau calage

Teta_0_rd = Calage_rad # Attention, Calage_deg a été modifié
L = [0.105,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55]
for x in L:
    Resolution(x,Teta_0_rd,1.3,0)