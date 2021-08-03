clc
clear


syms x1 x2
x1_dot = 2*x2 - x1;
x2_dot = -2*x1 - x2;
f = [x1_dot, x2_dot];
A = jacobian(f, [x1, x2]);

syms x1(t) x2(t) b
A = jacobian(1/2 * (x1(t)^4 + x2(t)^2), t);

disp(A)