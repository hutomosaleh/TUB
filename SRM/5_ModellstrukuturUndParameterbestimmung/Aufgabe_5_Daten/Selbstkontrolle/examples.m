N=5; %N - order
Ts=0.05; %Ts - Sampling time
p=25; %p - frequency divider (integer) 
n=3;  %n - number of repetitions
Mean=0.2; 
Amp=0.1;
[t,u]=prbs(N,p,n,Ts,Mean,Amp);

var_e=0.5;

%d=2;2 Pole, keine Nullstelle, OE
A1=[1.0000   -1.6    0.7];
B1=[0 0 .2];
D1=1;
C1=1;

%d=2;2 Pole, keine Nullstelle, ARX
A2=[1.0000   -1.6    0.7];
B2=[0 0 .2];
D2=A2;
C2=1;

%d=2;2 Pole, keine Nullstelle, ARX mit Nullstelle 
A3=[1.0000   -1.6    0.7];
B3=[0 1 -.2];
D3=A3;
C3=1;

%d=3;2 Pole, keine Nullstelle, BJ mit D=1-q^(-1), C=1-0.3 
A4=[1.0000   -1.6    0.7];
B4=[0 1 -.2];
C4=[1 -0.3];
D4=[1 -1];