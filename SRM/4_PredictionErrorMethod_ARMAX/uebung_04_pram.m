clc; clear;
% - Simulink Init -
Delta = 1; A_wahr = [1,  -1.6, 0.65]; 
B_wahr = [0.15]; C_wahr = [1, -0.5];

% - Datensatz laden -
load('data_3k_script.mat');
laenge = length(data);
y = data(2,2:laenge); u = data(3,2:laenge);

% - PEM Init -
thetaw = [-1.6, 0.65, 0.15, -0.5]'; % Wahren Parameter
theta0 = [-1.3, 0.8, 0.3, -0.3]';
eta = 1; eta_max = 10;
gamma = 1.1;
theta = theta0;
l = 1; l_max = 100; J_goal = 1/2*laenge*(1e-3)^2;
[E, J, G] = calc_mat(theta, u, y);
c=1;
while(l<l_max && ~(J-J_goal<0))
    J_alt = J;
    if(eta>5)
        theta = theta - 1/eta*G'*E;
    elseif(eta<1e-1)
        theta = theta - inv(G'*G)*G'*E;
    else
        theta = theta - inv(G'*G+eta*eye(4))*G'*E;
    end
    [E, J, G] = calc_mat(theta, u, y);
    if(J>J_alt)
        eta = eta*gamma;
    elseif(J<=J_alt)
        eta = eta/gamma;
        l = l+1;
    end
    if eta>eta_max
        break
    end
    disp(['J = ',num2str(J), ' - Iteration : ',num2str(l),...
        ' - Loop : ',num2str(c)]);
    disp(theta);disp('Korrekturmterm: ');
    disp(inv(G'*G+eta*eye(4))*G'*E);
    
    c=c+1;
    disp(['next eta: ',num2str(eta)])
end       
