clc; clear;

syms q_1 real
A = 1 - 0.9*q_1;
B = 0.5;
C = 1 + 0.5*q_1;
D = 1 - q_1;
d = 1;
i = 1;
X = 1;
Y = (1-q_1)^2;
Y = q_1^2 - 2*q_1 + 1;
% Vektorform
x = [1];
y = [1 -2 1];
a = [1 -0.9];
b = [0.5];
c = [1 0.5];
d = [1 -1];

% [G, H] = dio(X, Y, 1)
% [G, H] = dio(X, Y, 2)
% [G, H] = dio_gl(x, y, 1)
% [G, H] = dio_gl(x, y, 2)
% [G, H] = dio(B, A, i-d+1)
% [G, H] = dio_gl(b, a, i-d+1)
% [E, F] = dio(C, D, 1)
% [E, F] = dio_gl(c, d, 1)
% [E, F, G, H] = einSchrittVoraus(B, A, C, D, d, i)