% Modèle de l'axe linéaire complet
% A faire tourner avec le modèle SimScape "Modele_SimScape_ControlX.slx"
clear all
close all
clc

%--------------------------------------------------------------------------
%Paramètres  axe + moteur + variateur

i=3; % Rapport de réduction (entrée sur sortie)
Fext=30; % Une éventuelle force résistante supplémentaire exercée sur le chariot(N)
M=2.65; % Inertie du chariot + courroie + poulies + réducteur(kg)
Ffrott=30; % Force de frottement sec ramenée sur le chariot (N): mesurée expérimentalement
fv=20; %coefficient de frottement visqueux équivalent ramené sur le chariot : mesuré expérimentalement
R=155/6.28/1000; % Rayon de la poulie (m) Donnée constructeur : 155mm / tour de poulie
r=5.1; % Résistance de l'induit en (Ohms)
L=3.2e-3; % Inductance de l'induit (H)
k=0.21; % Constante de couple (N.m/A)
Unom=75; % Tension nominale moteur (V)
Cnom=0.34; % Couple nominal moteur
wnom=3000; % Vitesse nominale (tr/min)
Jmot=0.037e-3; % Moment d'inertie du moteur seul(kg.m2)
wmax=3367; % Vitesse à vide pour une tension d'alim de 75 V (tr/min)
Cmax=3.07; % Couple arbre bloqué pour une tension d'alim de 75 V (N.m)
B=4; %gain du variateur de vitesse
Ualim=40; % Tension alim max (V) : c'est la tension autorisée par le variateur compte tenu de son réglage
meq=M+Jmot*i^2/R^2;
Jeq=Jmot+M*R^2/i^2;
%--------------------------------------------------------------------------

sim('Modele_SimScape_ControlX') %Lancement du modèle Simulink
%--------------------------------------------------------------------------

figure(1)
hold on
Cmax2=3.5; %Pour tracés
wmax2=5500; %Pour tracés
%axis([-wmax2 wmax2 -Cmax2 Cmax2])
axis([0 wmax2 0 Cmax2])
grid
title('Caractéristiques moteur dans le plan C-\omega')
ylabel('Couple moteur (N.m)')
xlabel ('Vitesse moteur (tr/min)')

%--------------------------------------------------------------------------
%Courbes récupérées point à point d'après les caractéristiques constructeur
%1 : courbe de fonctionnement continu autorisé
%2 : courbe de fonctionnement "Repeated operation"
%3 : courbe de fonctionnement "Instantaneous operation"

C1=[0 0.0909 0.305 0.4545];
w1=[5000 5000 3000 0];

C2=3/132*[0 4 13.5 14 16.5 19 22 26 31 38 41.5 47.5 54 64 75 88 115 141 146 146];
w2=5000/192*[192 192 115 110 100 90 80 70 60 50 45 40 35 30 25 20 15 10 8 0];

C3=[0 0.284 0.352 0.432 0.489 0.568 0.648 0.739 0.83 0.92 1.045 1.159 1.284 1.443 1.614 1.795 1.920 2.034 2.193 2.352 2.602 2.92 3.307 3.318 3.318];
w3=5000/192*[192 192 180 168 160 150 140 130 120 110 100 90 80 70 60 50 45 40 35 30 25 20 15 10 0];

plot(w3,C3,'k','linewidth',3)
area(w3,C3,'FaceColor',[0.973 0.373 0.373])

plot(w2,C2,'k','linewidth',3)
area(w2,C2,'FaceColor',[1 0.6 0.6])

plot(w1,C1,'k','linewidth',3)
area(w1,C1,'FaceColor',[1 0.8 0.8])

%--------------------------------------------------------------------------
%Caractéristique couple-vitesse pour une tension d'alim de U0 V
% Utile pour un pilotage en BO par exemple sous U0 Volts
%--------------------------------------------------------------------------
wUalim=wmax*Ualim/Unom;
CUalim=Cmax*Ualim/Unom;
plot([wUalim 0],[0 CUalim],'b','linewidth',3)
%--------------------------------------------------------------------------
% Tracé de ce qui provient de Simscape
%--------------------------------------------------------------------------

plot(wSim*60/6.28,CSim,'ro','linewidth',1)
%plot(wSim2*60/6.28,CSim2,'k+','linewidth',1)

%On rajoute ici des commentaires pour qu'ils apparaissent au dessus de tous
%les tracés. Cela rend le code moins lisible mais le graphique est lui
%plus lisible.

text(100,0.2,' Fonctionnement continu','BackgroundColor',[1 0.6 0.6])
text(100,2,' Fonctionnement intermittent','BackgroundColor',[0.973 0.373 0.373])
text(2000,0.95,' Fonctionnement instantané','BackgroundColor',[1 0.6 0.6])
text(wUalim,0.2,strcat('Caractéristique moteur sous  ',num2str(Ualim),' V'),'BackgroundColor',[0.3 .6 .9])


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% On fait la même chose mais dans le plan F-V
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
figure(2)
hold on
grid
Fmax=3.5/(R/i);
Vmax=5500*R/i*6.28/60;
%axis([-Vmax Vmax -Fmax Fmax ])
axis([0 Vmax 0 Fmax])
grid
title('Caractéristiques moteur dans le plan F-V')
ylabel('Force motrice (N)')
xlabel ('Vitesse chariot (m/s)')

F1=C1/(R/i);
V1=R/i.*w1*6.28/60;
F2=C2/(R/i);
V2=R/i*w2*6.28/60;
F3=C3/(R/i);
V3=R/i*w3*6.28/60;

plot(V3,F3,'k','linewidth',3)
area(V3,F3,'FaceColor',[0.973 0.373 0.373])

plot(V2,F2,'k','linewidth',3)
area(V2,F2,'FaceColor',[1 0.6 0.6])

plot(V1,F1,'k','linewidth',3)
area(V1,F1,'FaceColor',[1 0.8 0.8])

%Caractéristique couple-vitesse pour une tension d'alim de U0 V
%Utile pour un pilotage en BO par exemple
VUalim=wUalim*R/i*2*pi/60;
FUalim=CUalim*i/R;
plot([VUalim 0],[0 FUalim],'b','linewidth',3)
%--------------------------------------------------------------------------
%Tracé de ce qui provient de Simscape
plot(wSim*R/i,CSim/(R/i),'r+','linewidth',1)
%--------------------------------------------------------------------------
%On rajoute ici des commentaires pour qu'ils apparaissent au dessus de tous
%les tracés. Cela rend le code moins lisible mais le graphique est lui
%pluis lisible.

text(0.2,20,' Fonctionnement continu','BackgroundColor',[1 0.6 0.6])
text(0.2,250,' Fonctionnement intermittent','BackgroundColor',[0.973 0.373 0.373])
text(2,100,' Fonctionnement instantané','BackgroundColor',[1 0.6 0.6])
text(1.6,20,strcat('Caractéristique moteur linéaire équivalent sous   ',num2str(Ualim),' V'),'BackgroundColor',[0.3 .6 .9])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Tracé de ce qui provient de Simscape dans le plan U-I, 4 quadrants
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if true
    figure(3)
    hold on
    Umax=80;
    Imax=15;
    axis([-Imax Imax -Umax Umax])
    grid
    title('Caractéristiques moteur dans le plan U-I')
    xlabel('Intensité moteur (A)')
    ylabel ('Tension moteur (V)')
    
    %--------------------------------------------------------------------------
    %Quadrants moteurs en rouge
    %--------------------------------------------------------------------------
    area([0 Imax],[Umax Umax],'FaceColor',[1 0.8 0.8])
    text(Imax/2,Umax,'Quadrant moteur','VerticalAlignment','top','HorizontalAlignment','center')
    area([-Imax 0],[-Umax -Umax],'FaceColor',[1 0.8 0.8])
    text(-Imax/2,-Umax,'Quadrant moteur','VerticalAlignment','bottom','HorizontalAlignment','center')
    
    %--------------------------------------------------------------------------
    %Quadrants résistants en bleu
    %--------------------------------------------------------------------------
    area([0 Imax],[-Umax -Umax],'FaceColor',[0.67 0.92 1])
    text(Imax/2,-Umax,'Quadrant résistant','VerticalAlignment','bottom','HorizontalAlignment','center')
    area([-Imax 0],[Umax Umax],'FaceColor',[0.67 0.92 1])
    text(-Imax/2,Umax,'Quadrant résistant','VerticalAlignment','top','HorizontalAlignment','center')
    
    plot(ISim,USim,'r+','linewidth',1)
end
