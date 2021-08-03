function [model,params] = create_model()
%
% Model from ...

%% Model parameters
params.A_G=0.9; %unitless
params.D_G=0;
params.S_G=0.014; %1/min
params.G_B=100;   %mg/dl
params.V=1.7;     %dl/kg

%Patient individual parameters
p2_patient_117_iv1=0.012;       %1/min
S_I_patient_117_iv1=7.73*1E-4;  %1/min per uU/ml
I_B_patient_117=11.01;          %uU/ml
p3_patient_117_iv1=0.017;       %1/min
S_N_patient_117_iv1=1.38*1E-4;  %1/min per pg/ml
N_B_patient_117=46.30;          %pg/ml
tmax_G_patient_117_iv1=69.6;    %min
ke_patient_117=0.196;           %1/min
V_I_patient_117=21.10;          %ml/kg
tmax_I_patient_117=54.36;       %min
kn_patient_117=0.62;            %1/min
V_N_patient_117=16.06;          %ml/kg
tmax_N_patient_117=32.46;       %min

params.p2=p2_patient_117_iv1;
params.S_I=S_I_patient_117_iv1;
params.I_B=I_B_patient_117;
params.p3=p3_patient_117_iv1;
params.S_N=S_N_patient_117_iv1;
params.N_B=N_B_patient_117;
params.tmax_G=tmax_G_patient_117_iv1;
params.ke=ke_patient_117;
params.V_I=V_I_patient_117;
params.tmax_I=tmax_I_patient_117;
params.kn=kn_patient_117;
params.V_N=V_N_patient_117;
params.tmax_N=tmax_N_patient_117;

%% determine basal operating point
params.x1_R=100; %blood sugar
params.u2_R=0; %no glugacon
params.u3_R=0; %no meal
%x contains all states plus x(12)=u1_R

f=@(x)eqns_bsc(x,params);%needed for calling eqns_bsc in fsolve
%without params
x=[100;zeros(11,1)];
[xres]=fsolve(f,x,optimoptions('fsolve','Display','off'));
params.x1_R=xres(1);
params.x2_R=xres(2);
params.x3_R=xres(3);
params.u1_R=xres(12);
params.x0=xres(1:11);

%% Linearisation
%DGLs -> 12 States G,X,Y,F,Ra,I,S1,S2,N,Z1,Z2,G_sensor
params.T_sensor=20;
AA=[[-params.S_G-params.x2_R+params.x3_R,-params.x1_R,params.x1_R,...
    0,1/params.V,0,0,0,0,0,0,0];
    [0,-params.p2,0,0,0,params.p2*params.S_I,0,0,0,0,0,0];
    [0,0,-params.p3,0,0,0,0,0,params.p3*params.S_N,0,0,0];
    [0,0,0,-1/params.tmax_G,0,0,0,0,0,0,0,0];
    [0,0,0,1/params.tmax_G,-1/params.tmax_G,0,0,0,0,0,0,0];
    [0,0,0,0,0,-params.ke,0,1/(params.tmax_I*params.V_I),0,0,0,0];%I 6
    [0,0,0,0,0,0,-1/params.tmax_I,0,0,0,0,0]; % S1 7
    [0,0,0,0,0,0,1/params.tmax_I,-1/params.tmax_I,0,0,0,0]; %S2 8
    [0,0,0,0,0,0,0,0,-params.kn,0,1/(params.tmax_N*params.V_N),0];
    [0,0,0,0,0,0,0,0,0,-1/params.tmax_N,0,0];%TS sign error in the paper
    [0,0,0,0,0,0,0,0,0,1/params.tmax_N,-1/params.tmax_N,0];
    [1/params.T_sensor,0,0,0,0,0,0,0,0,0,0,-1/params.T_sensor]];
BB=[[0,0,0];[0,0,0];[0,0,0];[0,0,params.A_G/params.tmax_G];...
    [0,0,0];[0,0,0];[1,0,0];[0,0,0];[0,0,0];[0,1,0];[0,0,0];[0,0,0]];
CC=[[0,0,0,0,0,0,0,0,0,0,0,1]];
DD=[[0,0,0]];

%% Determine discrete time transfer functions
%Sampling time
Ts=5;

% Model 1, model reduction, discretisation, conversion into transfer function
M1=ss(AA,BB(:,1),CC,0);
rM1 = balred(M1,4);
rM1.d=0;
figure;
subplot(1,3,1)
step(M1);hold on;
step(rM1);
G1d=c2d(tf(rM1),Ts,'zoh');
step(G1d);
%figure;
%pzmap(G1d);

%make a minimum phase approximation
dcgain_G1d=dcgain(G1d);
B=cell2mat(G1d.num);B=B(2:end);
A=cell2mat(G1d.den);
B_mod=B(2:end);
% B_zeros=roots(B_mod);
% B_zeros_new=[1/B_zeros(1);1/B_zeros(2)];
%
% B_new=poly(B_zeros_new);
%
% B_new=poly(B_zeros);
B_new=B_mod;
A = [A 0 0 0];
DCgain_new=sum(B_new)/sum(A);
B_new=B_new*dcgain_G1d/DCgain_new;
G1d_mp=tf(B_new,A,Ts);
step(G1d_mp);
title('G1: u1->y');
%
% % Model 2, model reduction, discretisation, conversion into transfer function
M2=ss(AA,BB(:,2),CC,0);
rM2 = balred(M2,4);
rM2.d=0;
subplot(1,3,2)
step(M2);hold on;
step(rM2);
G2d=c2d(tf(rM2),Ts,'zoh');
step(G2d);

%make a minimum phase approximation
dcgain_G2d=dcgain(G2d);
B=cell2mat(G2d.num);B=B(2:end);
A=cell2mat(G2d.den);
B_mod=B(2:end);
B_zeros=roots(B_mod);
A=[A 0 0 0];
B_zeros_new=B_zeros;
B_new=poly(B_zeros_new);
DCgain_new=sum(B_new)/sum(A);
B_new=B_new*dcgain_G2d/DCgain_new;
G2d_mp=tf(B_new,A,Ts);
step(G2d_mp);
title('G2: u2->y');

% Model 3, model reduction, discretisation, conversion into transfer function
M3=ss(AA,BB(:,3),CC,0);
rM3 = balred(M3,3);
rM3.d=0;
subplot(1,3,3)
step(M3);hold on;
step(rM3);
G3d=c2d(tf(rM3),5,'zoh');
step(G3d);
title('G3:u3->y');

%% General Plant for Controller Design
% only Gd1/Gd2_mp*1/z^2 can be realized
% therefore we assume Gd1/z^2 as general plant for MPC design
Gd=G1d_mp;
set(Gd,'Variable','z^-1');
G_prefilter=G1d_mp/G2d_mp;
model.G_prefilter=G_prefilter;

% Determine Polynomials in q^-1 with coefficients in increasing power of q^-1
A=cell2mat(Gd.den);
while(A(end)==0) A=A(1:end-1); end
model.A=A;
d=0;
B=cell2mat(Gd.num);
while(B(1)==0) B=B(2:end); d=d+1; end
model.B=B;
model.d=d;
model.Ts=Ts;
model.u_lb=-1000;%100*5*29.4/dcgain(G1d/G2d)
model.u_ub=800;%2*392.15;

%%Meal plant
set(G3d,'Variable','z^-1');
Ad=cell2mat(G3d.den);
Bd=cell2mat(G3d.num);
while(Ad(end)==0) Ad=Ad(1:end-1); end
model.Ad=Ad;
dd=0;
while(Bd(1)==0) Bd=Bd(2:end); dd=dd+1; end
model.Bd=Bd;
model.dd=dd;

%model.D=conv([1 -1],Ad);
%model.C=poly([C_pol]);
%model.C=conv(model.C,model.C) 
%model.C=conv(model.C,model.C)


%% set initial x(1) for simulation
params.x1_0=60; %blood sugar
params.u1_0=0;
params.x0(1)=params.x1_0;
model.u0=params.u1_0;
model.y0=params.x1_0;
end