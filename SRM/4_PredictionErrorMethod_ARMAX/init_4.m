clc
clear

% Wahres System
A = [1 -1.6 0.64];
B = 0.15;
C = 0.5;
Delta=1;

% Initialwerte
Theta0 = [-1.3 0.8 0.3 -0.3];
lmax = 10;
eta0 = 1;
gamma = 11;

% MAT-Datei speichern
stop_time = 3000;
step_time = stop_time;
simout = sim('Model_Uebung_4.slx');
data_3k = simout.y;
save('dataset_3k_script.mat', 'data_3k')

stop_time = 6000;
step_time = stop_time;
simout = sim('Model_Uebung_4.slx');
data_6k = simout.y;
save('dataset_6k_script.mat', 'data_6k')