clc
clear
close all

%{
    RET - Wind Assignment

    Submitted by:
    Heesun Jo
    Hutomo Saleh
%}

%% Parameters

Ptur = 3.5e6; % Rated power [W]
Pel = Ptur;
Vw = 12; % Rated wind speed [m/s]
n = 20; % Rated mechanical angular velocity [rpm]
Cp_opt = 0.4378; % Maximum power coefficient
r = 50; % Rotor radius [m]
lambda_opt = 6.7; % Optimal tip speed ratio
H = 6; % Inertia constant of turbine & PMSG [s]
p = 180; % Number of Poles
Rs = 60e-3; % Stator resistance [Ohm]
Lsd = 6e-3; % Stator d-axis inductance [H]
Lsq = 8e-3; % Stator q-axis inductance [H]
Phi_m = 17.3; % Flux induced by magnets [Wb]
V_dc = 6.5e3; % DC Voltage [V]
rho = 1.225; % Air density [kg/m3]

%% Assignment 1

wm = n / 60 * 2 * pi;
we = wm * (p / 2);
Te_rated = (Ptur * p) / (2 * we);
v_sd = 0;
v_sq = Phi_m * we;
v_s = 1 / sqrt(2) * sqrt(v_sd^2 + v_sq^2);
v_s_phase = sqrt(3) * v_s;
Te = 0:1e3:Te_rated;

i_sq_mat = zeros(1, length(Te));
i_sd_mat = zeros(1, length(Te));
for i=2:length(Te)
    % Newton-Rhapson Method w/ 10 Iteration
    % Using equations 25 & 26
    for iteration=1:10
        f = i_sq_mat(i)^4 + Phi_m * Te(i) * i_sq_mat(i) / (3/2*p/2*(Lsd-Lsq)^2) ...
            - (Te(i) / (3/2*p/2*(Lsd-Lsq)))^2;
        df = 4*i_sq_mat(i)^3 + Phi_m*Te(i) / (3/2*p/2*(Lsd-Lsq)^2);
        di = f / df;
        i_sq_mat(i) = i_sq_mat(i) - di;
    end
    
    i_sd_mat(i) = -Te(i) / (3/2 * p/2 * (Lsd-Lsq) * i_sq_mat(i)) ...
                  + Phi_m / (Lsd-Lsq);
end

% Plot
figure(1)
i_s = (i_sq_mat.^2 + i_sd_mat.^2).^(1/2) / sqrt(2);
plot(Te, i_s, Te, i_sq_mat, Te, i_sd_mat);
xlabel('Electrical Torque in Nm')
ylabel('Reference current in A')
legend('i_{s}', 'i_{sq,ref}', 'i_{sd,ref}')

%% Assignment 2

% Calculate controller parameters
tau_i = 3e-3; % [s]
Kq_p = - Lsq / tau_i;
Kd_p = - Lsd / tau_i;
Kq_i = Rs * Kq_p / Lsq;
Kd_i = Rs * Kd_p / Lsd;

% 2.1 a
delta_q = -25;
i_sq_ref = i_sq_mat(end); % Get last value of isq_ref
i_sq = i_sq_ref + delta_q;
simout_21 = sim('Task2_1.slx');
t_21 = simout_21.tout;
isq_21 = simout_21.isq;
isq_ref_21 = simout_21.isq_ref;

figure(1)
plot(t_21, isq_21, t_21, isq_ref_21)
grid on
xlabel('Time [s]')
ylabel('Stator Current in q-Frame [W]')
legend('isq', 'isq_ref')

% 2.1 b
matrix_diff = abs(i_sq_mat - i_sq); % Find difference of isq value
index = matrix_diff == min(matrix_diff); % Get index of minimum value
i_sd_ref = i_sd_mat(end); % Get last value of isd_ref
i_sd = i_sd_mat(index); % Use index to find corresponding isd
delta_d = i_sd_ref - i_sd; % Calculate delta

% 2.1 c
index = 43;
i_sq_calc = i_sq_mat(end-index);

% 2.2 
Vdc = 6e3; % Rated DC Voltage [V]

simout_22 = sim('Task2_2.slx');
t_22 = simout_22.tout;
isq_22 = simout_22.isq;
isd_22 = simout_22.isd;
isq_ref_22 = simout_22.isq_ref;
isq_ref_22 = isq_ref_22*ones(1, length(t_22));
isd_ref_22 = simout_22.isd_ref;
isd_ref_22 = isd_ref_22*ones(1, length(t_22));
mq_22 = simout_22.mq;
md_22 = simout_22.md;
vsq_22 = simout_22.vsq;
vsd_22 = simout_22.vsd;
idc_22 = simout_22.idc;
Pel_22 = simout_22.Pel;

figure("name", "Plot of isq, isd, mq, md, vsq & vsd");
subplot(311)
plot(t_22, mq_22, t_22, md_22)
subtitle("Modulation over time")
xlabel('t [s]')
ylabel('m')
legend('mq', 'md')
subplot(312)
plot(t_22, isq_22, t_22, isq_ref_22, t_22, isd_22, t_22, isd_ref_22)
subtitle("Stator reference current over time")
xlabel('t [s]')
ylabel('i [A]')
legend('isq', 'isq_ref', 'isd', 'isd_ref')
subplot(313)
plot(t_22, vsq_22, t_22, vsd_22)
subtitle("Stator voltage over time")
xlabel('t [s]')
ylabel('vs [V]')

figure("name", "Stator current and output power");
subplot(211)
plot(t_22, idc_22)
subtitle("Stator DC Current over time")
xlabel('t [s]')
ylabel('idc')
subplot(212)
plot(t_22, Pel_22)
subtitle("Output power over time")
xlabel('t [s]')
ylabel('Pel [W]')

%% Assignment 3

% Parameters
Vw_3 = 10; % Wind speed for 3rd Task [m/s]
c0 = 2.25e-2;
c1 = 2.18e-2;
c2 = -0.23e-2;

% 3.1 a
Sb = Pel;
J = H * 2 * Sb / wm^2;
% 3.1 b
wm_opt = lambda_opt * Vw_3 / r; % mechanical angular velocity [rpm]
we_opt = p / 2 * wm_opt; % electrical angular velocity [rpm]
Ct_opt = c0 + c1*lambda_opt + c2*lambda_opt^2;
Cp_opt = lambda_opt * Ct_opt;
Ptur_opt = 4 / p^3 * pi * rho * r^5 * we_opt^3 * Cp_opt / lambda_opt^3; % [W]
Pe_opt = Ptur_opt;
Te_opt = Pe_opt * p / (2 * we_opt);
% 3.1 c
a1 = c0 * pi * rho * r^3;
a2 = c1 * pi * rho * r^4 / p;
a3 = 4 * c2 * pi * rho * r^5 / p^2;
D = 0; % No damping torque
tau_w = - 2 * J / (p * (a2*Vw_3 + a3*we_opt - D*2/p));
tau_z = tau_w / (1 - p * tau_w * Te_opt / (2 * we_opt * J));
% 3.1 d
dVw = 0;
dTe = 1e5;
simout_31 = sim('Task3_1.slx');
dwe1 = simout_31.dwe;
dPel1 = simout_31.dPel;
t_31 = simout_31.tout;

dVw = 0.1; % New wind speed [m/s]
simout_31 = sim('Task3_1.slx');
dwe2 = simout_31.dwe;
dPel2 = simout_31.dPel;

% Plot
figure(3)
plot(t_31, dwe1, t_31, dwe2);
xlabel('Time [s]')
ylabel('Changes of Electrical Angular Velocity [1/s]')
legend('Constant Vw', 'dVw = 0.1 m/s')
figure(4)
plot(t_31, dPel1, t_31, dPel2);
xlabel('Time [s]')
ylabel('Changes of Power [W]')
legend('Constant Vw', 'dVw = 0.1 m/s')

% 3.2 a b c
Te = Te_opt; % Because of Vw = 10 m/s
lambda = (0:1e-2:20);
Ct = c0 + c1.*lambda + c2*lambda.^2;

simout_32 = sim('Task3_2.slx');
Ttur_32 = simout_32.Ttur;
t_32 = simout_32.tout;
figure(5)
plot(t_32, Ttur_32, t_32, Te*ones(1, length(t_32)));
xlabel('Time [s]')
ylabel('Torque [Nm]')
legend('Ttur', 'Te')

% 3.3 a
% Same calculation as Assignment 1
Te = 0:1e3:Te_opt;
i_sq_opt = zeros(1, length(Te));
i_sd_opt = zeros(1, length(Te));
for i=2:length(Te)
    for iteration=1:10
        f = i_sq_opt(i)^4 + Phi_m * Te(i) * i_sq_opt(i) ...
            / (3/2*p/2*(Lsd-Lsq)^2) - (Te(i) / (3/2*p/2*(Lsd-Lsq)))^2;
        df = 4*i_sq_opt(i)^3 + Phi_m*Te(i) / (3/2*p/2*(Lsd-Lsq)^2);
        di = f / df;
        i_sq_opt(i) = i_sq_opt(i) - di;
    end
    i_sd_opt(i) = -Te(i) / (3/2 * p/2 * (Lsd-Lsq) * i_sq_opt(i)) ...
                  + Phi_m / (Lsd-Lsq);
end
i_sq_opt = i_sq_opt(end);
i_sd_opt = i_sd_opt(end);
% 3.3 b
simout_33 = sim('Task3_3.slx');
we_33 = simout_33.we;
t_33 = simout_33.tout;
figure(6)
plot(t_33, we_33)
xlabel('Time [s]')
ylabel('Electrical Angular Velocity [Nm]')
legend('We')

%% Assignment 4

% 4.1
tau_le = tau_w;
tau_lg = tau_z;
tau_pl = 0.05 * tau_w;
K = p * tau_z / (tau_pl * 2*we * tau_w);
Pel_err = -50e3; % Change in reference power [W]

simout_41 = sim('Task4_1.slx');
Pel_err_plot = simout_41.Pel_err;
t_41 = simout_41.tout;
figure(7)
plot(t_41, Pel_err_plot)
xlabel('Time [s]')
ylabel('Power Change [kNm]')
legend('Pel')
% 4.3
Te = 0:1e3:Te_rated;
simout_43 = sim('Task4_3.slx');
Te_43 = simout_43.Te;
Pe_43 = simout_43.Pe;
we_43 = simout_43.we;
t_43 = simout_43.tout;

figure("name", "Plot of Te, Pel and we");
subplot(311)
plot(t_43, Pe_43)
xlabel('Time [s]')
ylabel('Electric Power [W]')
subplot(312)
plot(t_43, we_43)
xlabel('Time [s]')
ylabel('Electric Angular Velocity [Nm]')
subplot(313)
plot(t_43, Te_43)
xlabel('Time [s]')
ylabel('Electric Torque [Nm]')
% 4.4
% Generate wind noise
t_44 = (1:300);
rng('default')
noise = -0.5 + 1*rand(1, length(t_44));
Vw = Vw_3 + noise;
Vw_ts = timeseries(Vw', t_44);
save("wind_speed_fluct.mat", 'Vw_ts', '-v7.3')
simout_44 = sim('Task4_4.slx');

t_44 = simout_44.tout;
Te_44 = simout_44.Te;
isq_44 = simout_44.isq;
isd_44 = simout_44.isd;
Pel_44 = simout_44.Pel;
Cp_44 = simout_44.Cp;
we_44 = simout_44.we;

figure("name", "Plot of Te, isd and isq");
subplot(311)
plot(t_44, Te_44)
subtitle("Torque over time")
xlabel('Time [s]')
ylabel('Torque [Nm]')
subplot(312)
plot(t_44, isq_44)
subtitle("Stator Current in q-Frame over time")
xlabel('t [s]')
ylabel('isq [A]')
subplot(313)
plot(t_44, isd_44)
subtitle("Stator Current in d-Frame over time")
xlabel('t [s]')
ylabel('isd [A]')

figure("name", "Plot of Pe vs we and Cp vs Te");
subplot(211)
plot(we_44, Pel_44)
subtitle("Electrical Power vs El. Angular Velocity")
xlabel('we[rad/s]')
ylabel('Pel [W]')
subplot(212)
plot(Te_44, Cp_44)
subtitle("Power Coefficient vs Torque")
xlabel('Te [Nm]')
ylabel('Cp [s]')

figure("name", "Wind Fluctuation")
plot(Vw)
title("Wind Fluctuation over Time")
xlabel('Time [s]')
ylabel('Wind Speed [m/s]')

% 4.4 e
% Get minimal and maximal value of Vw and its corresponding Pe.
min_Vw = min(Vw);
max_Vw = max(Vw);
min_Pe = min(Pel_44(200:end));
max_Pe = max(Pel_44(200:end));
min_index = find(Pel_44(200:end) == min_Pe);
max_index = find(Pel_44(200:end) == max_Pe);
min_Cp = Cp_44(min_index);
max_Cp = Cp_44(max_index);

min_Pe_theory = 1 / 2 * pi * rho * r^2 * min_Vw^3 * min_Cp;
max_Pe_theory = 1 / 2 * pi * rho * r^2 * max_Vw^3 * max_Cp;