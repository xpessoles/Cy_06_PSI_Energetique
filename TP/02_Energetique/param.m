%--------------------------------------------------------------    
% Control'X
%--------------------------------------------------------------  
    clc %efface la fen�tre de commande
    dt=1e-4; %Pas de temps du solveur discret utilis� et p�riode d'�chantillonnage en cas de pilotage temps r�el

%--------------------------------------------------------------    
% Donn�es g�om�triques
%--------------------------------------------------------------    

    R = 155/(2*pi)/1000; % Rayon de la poulie (m) // 155mm : avance par tour de poulie crant�e
    i = 3;    % Reducteur : Il s'agit d'une r�duction !
    
%--------------------------------------------------------------    
% Donn�es propres au moteur
%--------------------------------------------------------------   
    
    r = 5.1; %R�sistance de l'induit (Ohms)
    %L = 3.2e-3; %Inductance de l'induit(H)
    L = 0
    kc = 0.21; %Constante de couple du moteur (N.m/A)
    ke = 0.2083; % Constante de force contre �lectromotrice (V/(rad/s))
    k = (kc+ke)/2; %Moyenne des deux constantes �lectrom�caniques
    
    kprim_c=kc*i/R;%Constante de couple du moteur lin�aire �q (N.m/A)
    kprim_e=ke*i/R;% Constante de force contre �lectromotrice du moteur lin�aire �q (V/(rad/s))
    kprim=(kprim_c+kprim_e)/2;%moyenne des deux valeurs pr�cedentes
     
%--------------------------------------------------------------    
% Donn�es propres au variateur
%--------------------------------------------------------------   
    
    B = 4; %gain pur du variateur de vitesse

%--------------------------------------------------------------    
% R�sistances passives : Donn�es d'origine exp�rimentale
%--------------------------------------------------------------   
    
    Ffrott = 28; %Fottement sec de tout l'�quipage mobile ramen� sur le chariot :  N 
    fv = 20; % Coefficient de frottement visqueux de tout l'�quipage mobile ramen�s sur le chariot : N/(m/s)
    
    Cfrott = Ffrott*R/i; %Frottement sec ramen� sur le moteur : N.m
    fw = fv*R^2/i^2;  % Coefficient de frottement visqueux ramen� sur le moteur : N.m/(rad/s)
    
    Vseuil = Cfrott*r/kc; % Modd�lisation de l'effort de frottement sec ramen� en entr�e du moteur : mod�le moins fin qu'un effort de frottement sec mais plus souple en terme de simulation num�rique : V

%--------------------------------------------------------------    
% Donn�es propres � la carte de commande
%--------------------------------------------------------------  
    
    Vsat = 10;     %Tension de saturation : Volts
    
%--------------------------------------------------------------    
% Donn�es inertielles propres � l'ensemble du m�canisme
%--------------------------------------------------------------  

    meq = 3.2; %Masse �quivalente de tout l'�quipage mobile ramen�e sur le chariot (kg): origine exp�rimentale pour l'instant
    Jeq = meq*(R/i)^2; % Moment d'inertie �quivalent de tout l'�quipage mobile ramen�e sur le moteur (kg.m2)
    
%--------------------------------------------------------------    
% Donn�es propres � la cha�ne de retour
% Encodeur incr�mental mont� sur l'arbre moteur (axe X)
%--------------------------------------------------------------  
    
    C=1000*4/(2*pi); %points par radian de rotation de moteur, d�cod� en *4
    D=R/(i*C)*1000; % en mm/inc     
        
%--------------------------------------------------------------      
%D�tail du calcul de m�q
%-------------------------------------------------------------- 

I1=0.037e-3+0.012e-3+8e-8; %Moteur+g�n� tachy + encodeur
Ir=0.135e-4; % R�ducteur ramen� sur l'entr�e
I2roulement=2*(8349e-9+18*7/20*0.82e-3*19.5e-3^2); %2 bagues int de roulement � billes + billes mont�es sur  poulie crant�e
I3=4.7e-5+0.09e-4+0.013e-4+0.15e-4+I2roulement; % Poulie+accouplement (2 parties) + bagues int de roulement � billes
m4=0.16; % Courroie
m5=0.9;% Chariot : ici il faudrait rajouter les petites bricoles fix�es sur le chariot.
I6=4.7e-5+0.01e-4+I2roulement; %Poulie crant�e+bague int de roulement � billes
Jeq = I1+Ir+1/i^2*(I3+I6+(m4+m5)*R^2); % Ramen� sur le moteur
meq=Jeq*i^2/R^2; % Ramen� sur le chariot

disp ('Param�tres pris en compte')