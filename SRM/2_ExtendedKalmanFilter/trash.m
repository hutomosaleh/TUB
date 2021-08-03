clc
clear

x1_RL = 1000;
x2_RL = 550;

% 1)
syms x1 x2 x3 th1 th2 th3 th4 th5 th6 u d real
x1_dot = -th1*x1 - th2*x1*x3 + th1*x1_RL;
x2_dot = -th3*x2 + th4*x2*x3 + th3*x2_RL;
x3_dot = th5*x1*x3 - th6*x2*x3 - u;
theta = [th1 th2 th3 th4 th5 th6];
f = [x1 + d*x1_dot, x2 + d*x2_dot, x3 + d*x3_dot th1 th2 th3 th4 th5 th6]';
h = [x1 x2 x3]';

% 2)
A_sym = jacobian(f, [x1, x2, x3, th1, th2, th3, th4, th5, th6]);
B_sym = jacobian(f, u);
f_sym = f;
h_sym = h;

A = matlabFunction(A_sym, 'vars', [x1, x2, x3, th1, th2, th3, th4, th5, th6, d]);
B = matlabFunction(B_sym, 'vars', [x1, x2, x3, th1, th2, th3, th4, th5, th6, d]);
C = [eye(3), zeros(3, 6)];
f = matlabFunction(f_sym, 'vars', [x1, x2, x3, th1, th2, th3, th4, th5, th6, d, u]);
h = matlabFunction(h_sym, 'vars', [x1, x2, x3, th1, th2, th3, th4, th5, th6]);

% 3 & 4)

% init
u = 0;
k = 0;
d = 0.01;
x1 = 1000; x2 = 550; x3 = 0.0001;
th_wahr = [0.25 50 0.25 10 0.01 0.0045];
abweichung = 0.3;
th = (1 - abweichung)*th_wahr;
th1 = th(1); th2 = th(2); th3 = th(3); th4 = th(4); th5 = th(5); th6 = th(6);

P = 1.3^2*eye(9, 9); % P(0|0) <-- how to compute the error?
x0 = f(x1, x2, x3, th1, th2, th3, th4, th5, th6, d, u)';

jahr = 0.1; % Simulate until...

for i = 0:d:jahr
    
    noise = -1 + 2*rand(3, 1);
    Z = [100 100 10e-5]' .* noise;
    
    % Prediktion
    x_hat_k = f(x1, x2, x3, th1, th2, th3, th4, th5, th6, d, u);
    A_k = A(x1, x2, x3, th1, th2, th3, th4, th5, th6, d);
    P = A_k*P*A_k';

    % Update
    k = k + 1;
    d = d + 0.01;
    
    C_k1 = C;
    K = P*C_k1' * (Z + C_k1*P*C_k1')^-1;
    h_k = h(x1, x2, x3, th1, th2, th3, th4, th5, th6);
    y = h_k + Z;
    x_hat_k1 = x_hat_k + K*(y - h_k);
    P_k1 = P - K*C_k1*P;
end

disp(x0);
disp(x_hat_k1');
