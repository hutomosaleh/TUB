%Exercise PEM 
%TU Berlin
%Thomas Schauer

%load data from given ARMAX process 
load('uy.mat');
U=uy(2,:)';
Y=uy(3,:)';

%initialisation
theta=[-1.6,0.64,0.15,-0.5];%true
a1_hat=-1.3;
a2_hat=-0.8;
b_hat=0.3;
c_hat=-0.3;
theta_hat(:,1)=[a1_hat;a2_hat;b_hat;c_hat];

%parameters of Levenberg Marquardt algorithm
eta=1;
gam=1.1;

%Get initial estimate for starting values
%R residuals
%G Gradient
%J Cost function
[E,G,J]=model_evaluation(theta_hat(:,1),U,Y);

% plot true and estimated parameters over l
figure(1);
clf(1);
plot(0:10,theta(1)*ones(1,11),'r');hold on;
plot(0:10,theta(2)*ones(1,11),'g');
plot(0:10,theta(4)*ones(1,11),'k');
plot(0:10,theta(3)*ones(1,11),'b');

plot(0,a1_hat,'+r');
plot(0,a2_hat,'+g');
plot(0,b_hat,'+k');
plot(0,c_hat,'+b');
l=legend('$a_1$','$a_2$','$c$','$b$','$\hat a_1(l)$','$\hat a_2(l)$','$\hat c(l)$','$\hat b(l)$');
set(l,'Interpreter','Latex','fontsize',15);
title('PEM','fontsize',15);
xlabel('Iterationsschritt l','fontsize',15);
l=1;

%Levenberg Marquardt algorithm
while((l<10)&(eta<10e20))
    %Update parameters
    theta_hat(:,l+1)=theta_hat(:,l)-inv(G'*G+eta*eye(size(G'*G)))*G'*E;
    [E_neu,G_neu,J_neu]=model_evaluation(theta_hat(:,l+1),U,Y);
    if (J_neu>J) 
        eta = eta*gam;
    else
        eta = eta/gam;
        J=J_neu;
        G=G_neu;
        E=E_neu;
        % Plot results of successful step
        figure(1); 
        plot(l,theta_hat(1,l+1),'+r');
        plot(l,theta_hat(2,l+1),'+g');
        plot(l,theta_hat(3,l+1),'+b');
        plot(l,theta_hat(4,l+1),'+k');
        legend('$a_1$','$a_2$','$b$','$c$','$\hat a_1(l)$','$\hat a_2(l)$','$\hat b(l)$','$\hat c(l)$');
        l=l+1;
    end
end
% 
clc;
disp('Parameter estimates for all sucessfull update steps');
theta_hat
