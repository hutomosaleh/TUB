clear;
% Forward Euler Method
% Coefficients of equation y'=b y + c t; y(0) = 1

b = -2.0;
b = -1.0;
c = 1.0;
% Initial and final times
t_init = 0.0;
t_max = 5.0;

% Number of time steps
Nt = 3000;
tau = (t_max - t_init) / Nt;  % step size

% Initial condition
y(1) = 1.0;
t(1) = t_init;

% Time loop

% for j = 1:Nt
%     y(j+1) = y(j) + tau*(b * y(j) + c*t(j));
%     t(j+1) = t_init + j * tau;
% end

for j = 1:Nt
    y(j) = y(j-1) + tau*(b * y(j) + c*t(j));
    t(j+1) = t_init + j * tau;
end

plot(t, y)
title('Forward Euler method')
xlabel('T')
ylabel('y(t)')
