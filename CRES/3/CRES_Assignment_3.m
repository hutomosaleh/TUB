clc  % Clears command window
clear all  % Clears workspace, windows, etc (No need to close it again)

%% Variables
V_C_0 = 10;
C = 1e-3;  % Simplification of 10^-3
R = 1;

t_max = 10e-3;
t_max = 5e-3;  % For g) and h)
t = 0:1e-5:t_max;  % This format gives us an array
% t = 0.5e-3:1e-5:1e-3;  % For d)
lambda = - 1 / (R*C);

tau = abs(1 / lambda) * 0.9;  % 10% Smaller from the FE threshold (No reason why)
disp(tau)
% tau = 2*R*C;  % For g)
tau = 4*R*C;  % For h)

n = t / tau;

% Direct Solution
V_C = V_C_0 * exp(lambda * t);
% Backward Euler
V_C_be = V_C_0 * (1 - lambda * tau).^-n;  % '.' is needed because n is an array (due to t)
% Forward Euler
V_C_fe = V_C_0 * (1 + lambda * tau).^n;
% Trapezoidal
V_C_tr = ((1 + 0.5 * tau * lambda) ...  % '...' Allows us to continue lines (For formatting)
         / (1 - 0.5 * tau * lambda)).^n * V_C_0;
     
%% Oscillations
% +1% to make it larger than the threshold (to show the oscillation)
tau = abs(1 / lambda) * 1.01;
V_C_fe_oscillation = V_C_0 * (1 + lambda * tau).^n;  
tau = abs(2 / lambda) * 1.01;
V_C_tr_oscillation = ((1 + 0.5 * tau * lambda) ...
                     / (1 - 0.5 * tau * lambda)).^n * V_C_0;
       
%% Plot
plot(t, V_C, 'g', 'DisplayName', 'Direct')  % '--g' for line customization (g: green)
hold on  % To make the plot stays, so it doesn't get overwritten w/ new plot
plot(t, V_C_be, 'DisplayName', 'Backward-Euler')
hold on
plot(t, V_C_fe, 'DisplayName', 'Forward-Euler')
hold on
plot(t, V_C_tr, 'DisplayName', 'Trapezoidal')
% hold on
% plot(t, V_C_fe_oscillation, 'DisplayName', 'Forward-Euler (Oscillation)')
% hold on
% plot(t, V_C_tr_oscillation, 'DisplayName', 'Trapezoidal (Oscillation)')
grid on  % Enables grid### in figure
lgd = legend;  % Put figure legend as variable for customization
lgd.FontSize = 20;
title('Capacitor discharge')
xlabel('Time (s)')  % Sets label names
ylabel('Voltage across capacitor (V)')
set(gcf, 'Position', get(0, 'Screensize'))  % Sets the figure window to (somewhat) fullscreen
% gcf returns our current figure, so our set target

%% Notes
%{
To publish script/code as PDF, type:
publish('your_matlab_file.m', 'pdf')
in command window

CTRL+R to comment line(s)
CTRL+T to uncomment
%}
