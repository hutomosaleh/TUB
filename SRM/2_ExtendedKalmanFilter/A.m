function out = A(x, x_RL, Delta)
    syms x1 x2 x3 th1 th2 th3 th4 th5 th6 u d real
    x1_dot = -th1*x1 - th2*x1*x3 + th1*x_RL(1);
    x2_dot = -th3*x2 + th4*x2*x3 + th3*x_RL(2);
    x3_dot = th5*x1*x3 - th6*x2*x3 - u;
    f = [x1 + d*x1_dot, x2 + d*x2_dot, x3 + d*x3_dot th1 th2 th3 th4 th5 th6]';
    
    A_sym = jacobian(f, [x1, x2, x3, th1, th2, th3, th4, th5, th6]);
    A = matlabFunction(A_sym, 'vars', [x1, x2, x3, th1, th2, th3, th4, th5, th6, d]);
    out = A(x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8), x(9), Delta);
end