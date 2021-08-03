clc
clear

syms a1 a2 b c q1 q2 u y e
theta = [a1 a2 b c];
A = 1 + a1*q1 + a2*q2;
A1 = a1 + a2*q1;
B = b;
C = 1 - c*q1;
C1 = c;
% y_h = B/A*u + (C-A)/C * (y - B/A*u_km1);
y_h = -A1*y + B*u + C1*e;

y_ab = jacobian(y_h, theta);
disp(y_ab)
