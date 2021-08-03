R=50;%cmH2O/L/s
C=0.02;%L/cmH2O
V0=2;
Pinsp=20;
PEEP=5;
p0=(V0-C*PEEP)/(-C);
Ti=2;
Te=2;
%Sampling Time
Delta=0.01
%for p_PL 
tt=0:0.01:Ti;
yy=sin(2*pi/(Ti)*tt+pi*3/2)+1;

