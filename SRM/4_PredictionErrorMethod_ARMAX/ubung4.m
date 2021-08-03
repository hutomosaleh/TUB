clc
clear
close all

% Wahres System
A = [1 -1.6 0.64];
B = 0.15;
C = [1 -0.5];
Delta = 1;
% Theta0 = [-1.6 0.64 0.15 -0.5];

% Initialwerte
Theta0 = [-1.3 0.8 0.3 -0.3]';
lmax = 10;
eta0 = 1;
eta_max = 10;
gamma = 1.1;
d = 2;

% MAT-Datei speichern
% stop_time = 3000;
% step_time = stop_time;
% simout = sim('Model_Uebung_4.slx');
% data_3k = simout.y;
% save('dataset_3k_script.mat', 'data_3k')

dataname = '3k';
dataset = 'dataset_3k_script.mat';
file = load(dataset);
data = file.data_3k.Data;
u = data(1:end, 1);
y = data(1:end, 2);

% stop_time = 6000;
% step_time = stop_time;
% simout = sim('Model_Uebung_4.slx');
% data_6k = simout.y;
% save('dataset_6k_script.mat', 'data_6k')

% dataname = '6k';
% dataset = 'dataset_6k_script.mat';
% file = load(dataset);
% data = file.data_6k.Data;
% u = data(1:end, 1);
% y = data(1:end, 2);

theta = zeros(lmax, 4)';
theta(:, 1) = Theta0;
eta = eta0;
J_goal = 1/2*(length(y)-2)*(1e-3)^2;
theta_plot = [];

l = 1;
p = 1;
[E, J, G] = PEC(u, y, theta(:, l), d);
while (l<lmax && ~(J-J_goal<0))
    disp(sum(E))
%     disp(sum(sum(G)))
    J_alt = J;
    theta(:, l+1) = theta(:, l) - (G'*G+eta*eye(4))^-1 * G'*E;
    [E, J, G] = PEC(u, y, theta(:, l+1), d);
    if J>J_alt
        eta = eta * gamma;
    else
        l = l + 1;
        eta = eta / gamma;
        if eta >= eta_max
            break
        end
    end
    result = theta(:, l);
    theta_plot(:, p) = theta(:, l);
    p = p + 1;
%     disp("Eta:          J:        J(l+1):         l:")
%     disp([num2str(eta), num2str(J_alt), num2str(J), ""])
end

disp("result is: ")
disp(theta_plot)

N = length(theta_plot(1, :));
a1 = A(2)*ones(1, N);
a2 = A(3)*ones(1, N);
b = B*ones(1, N);
c = C(2)*ones(1, N);
x = (1:N);
hold on
title(['Dataset ', dataname, '  |  lmax = ', num2str(lmax)]);
plot(x, theta_plot(1, :), 'b', x, a1, 'b--')
plot(x, theta_plot(2, :), 'g', x, a2, 'g--')
plot(x, theta_plot(3, :), 'r', x, b, 'r--')
plot(x, theta_plot(4, :), 'c', x, c, 'c--')
l=legend('a1','a1_W', 'a2', 'a2_W', 'b', 'b_W', 'c', 'c_W');