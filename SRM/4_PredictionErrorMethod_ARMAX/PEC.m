function [E, J, G] = PEC(u, y, theta, d)
    K = length(y);
    init = zeros(1, K)';
    y_hat = y; E = init;
    dy.a1 = init; dy.a2 = init; dy.b = init; dy.c = init;
    a1 = theta(1); a2 = theta(2); b = theta(3); c = theta(4);
    for k=3:K
            dy.a1(k) = -y(k-1) - c*dy.a1(k-1);
            dy.a2(k) = -y(k-2) - c*dy.a2(k-1);
            dy.b(k) = u(k-d) - c*dy.b(k-1);
            dy.c(k) = E(k-1) - c*dy.c(k-1);
            
            y_hat(k) = -a1*y(k-1) - a2*y(k-2) + b*u(k-d) + c*E(k-1);
            E(k) = y(k) - y_hat(k);
    end
    
    E = E(3:end);
%     J = 0.5 * sum((y(3:end) - y_hat(3:end)).^2);
    J = 0.5*(E'*E);
    G = [dy.a1 dy.a2 dy.b dy.c];
    G = -G(3:end, :);
end