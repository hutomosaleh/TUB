clc
clear

%Polynome in q^-1 oder z^-1
A = [1 -1.6 0.64];
B = 0.15;
%u(k-2)=u(k)*q^-2
B_with_delay=[0 0 0.15];
C=1;

%LTI Systeme in q^-1
Delta=1;
G_qm1=tf(B_with_delay,A,Delta,'Variable','q^-1');
H_qm1=tf(C,A,Delta,'Variable','q^-1');

%Polynomer in q oder z
%(B(q^-1)q^-2)/A(q^-1) = (bq^-2)/(1+a1*q^-1+a2*q^-2)=y(k)/u(k)
%Btilde(q)/Atilde(q) = (B(q^-1)q^-2)/A(q^-1)*q^2/q^2
Atilde=[1 -1.6 0.64]; %q^2-1.6*q+0.64
Btilde=0.15; 
Ctilde=[1 0 0];%Ctilde(q)=q^2;

%LTI Systeme in q
G_q=tf(Btilde,Atilde,Delta,'Variable','z');
H_q=tf(Ctilde,Atilde,Delta,'Variable','z');

%Parameter für RLS

Theta0 = [0.15 -1.6  0.64];
Theta0 = [0 0 0];
p0 = [1 2 3];
P0 = p0(1)*eye(3);
