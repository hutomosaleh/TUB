function [E, J, G] = calc_mat(theta, ein, aus)
% - Init -
% y = [y(-1),y(0),...,y(K)], u = [u(-1),u(0),...,u(K)]
% E_ = [e(0),E(theta_l)], G_ = [g(0|a1),g(1|a1),...g(K|a1);...,g(K|c1)]

y = [0, 0, aus]; u = [0, 0, ein]; % addiere y(0) und y(-1) bzw. u
E_ = zeros(length(ein)+2,1); G_ = zeros(length(ein)+2,4);

% y_hat(k-1 = 0) initialisieren (für Berechnung von e(k-1 = 0)
y_hat_km1 = 0;

for i = 3:length(ein)+1
    % e(k-1) berechnen
    % E_(i-1) = y(i-1)-y_hat_km1;
    
    % partielle ableitungen dy_hat(k)/dtheta berechnen
    G_(i,1) = - y(i-1) - theta(4)*G_(i-1,1); 
    G_(i,2) = - y(i-2) - theta(4)*G_(i-1,2);
    G_(i,3) = u(i-2) - theta(4)*G_(i-1,3);
    G_(i,4) = E_(i-1) - theta(4)*G_(i-1,4);
    
    % y_hat(k) berechnen
    % y_hat_k = -a1*y_km1 - a2*y_km2 + b0*u_km2 + c1*e_km1
    y_hat_k = -theta(1)*y(i-1)-theta(2)*y(i-2)+theta(3)*u(i-2)+...
        theta(4)*E_(i-1);
    
    % y_hat_km1 updaten
    y_hat_km1 = y_hat_k;
    E_(i) = y(i)-y_hat_km1;
    
end

% for i = 3:length(ein)+2
%     % e(k-1) berechnen
%     E_(i-2) = y(i-1)-y_hat(2);           
%     
%     % partielle ableitung dy(k)/dtheta
%     G_(i,1) = -y_hat(2)-theta(1)*G_(i-1,1)-theta(2)*G_(i-2,1);
%     G_(i,2) = -y_hat(1)-theta(1)*G_(i-1,2)-theta(2)*G_(i-2,2);
%     G_(i,3) = u(i-1)-theta(1)*G_(i-1,3)-theta(2)*G_(i-2,3);
%     G_(i,4) = E_(i-2)-y_hat(1)-theta(1)*G_(i-1,4)-theta(2)*G_(i-2,4);
%     
%     % y_hat(k) berechnen
%     y_hat_kp1 = -theta(1)*y(i-1)-theta(2)*y(i-2)+theta(3)*u(i-2)+...
%         theta(4)*E_(i-2);
%     
%     % k = k+1
%     y_hat = [y_hat(2),y_hat_kp1];
% end
% E_(length(ein)+1) = y(length(ein)+2)-y_hat(1);
% 

E = E_(3:end);
G = -G_(3:end,:);
J = 0.5*(E'*E);
end

