clc; clear;
%% - Simulink Init -
Delta = 1; A_wahr = [1,  -1.6, 0.65]; 
B_wahr = [0.15]; C_wahr = [1, -0.5];

%% - Datensatz laden -
%load('dataset_3k_script.mat');
%data = [data_3k.Time, data_3k.Data(:,2) , data_3k.Data(:,1)]';
load('data_3k.mat');
laenge = length(data);
y = data(2,2:laenge); u = data(3,2:laenge);

%% - PEM Init -
thetaw = [-1.6, 0.65, 0.15, -0.5]'; % Wahren Parameter
theta0 = [-1.3, 0.8, 0.3, -0.3]';
eta = 1; eta_max = 10;
gamma = 1.1;
theta = theta0;
l = 1; l_max = 10; J_goal = 1/2*laenge*(1e-3)^2;
[E, J, G] = calc_mat(theta, u, y);
% theta0 = [-1.7, 1, 0.1, -0.7]';
% [E, J, G] = calc_mat(theta0, u, y);
% theta0 = [-1.6, 0.65, 0.15, -0.5]';
% [E, J, G] = calc_mat(theta0, u, y);
c=1;
result = theta;
while(l<l_max & ~(J-J_goal<0))
    J_alt = J;
    if(eta>5)
        theta = theta - 1/eta*G'*E;
    elseif(eta<1e-1)
        theta = theta - inv(G'*G)*G'*E;
    else
        theta = theta - inv(G'*G+eta*eye(4))*G'*E;
    end
    result = [result, theta];
    disp(sum(E))
%     disp(sum(sum(G)))
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
%     disp(['J = ',num2str(J), ' - Iteration : ',num2str(l),...
%         ' - Loop : ',num2str(c)]);
%     disp(theta);disp('Korrekturmterm: ');
%     disp(inv(G'*G+eta*eye(4))*G'*E);
    
    c=c+1;
%     disp(['next eta: ',num2str(eta)])
end       

%% Plot
disp("result is: ")
disp(result)
figure();hold on; grid on;
plot(1:1:c, result(1,:), 'b');
plot(1:1:c, thetaw(1)*ones(c), '.b');
plot(1:1:c, result(2,:), 'g');
plot(1:1:c, thetaw(2)*ones(c), '.g');
plot(1:1:c, result(3,:), 'k');
plot(1:1:c, thetaw(3)*ones(c), '.k');
plot(1:1:c, result(4,:), 'r');
plot(1:1:c, thetaw(4)*ones(c), '.r');



