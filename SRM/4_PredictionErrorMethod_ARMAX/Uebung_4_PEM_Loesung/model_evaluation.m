function [E,G,J]=model_evaluation(theta_hat,u,y)
    % initial values are assumed to be all zero
    %1=k-2
    %2=k-1
    %3=k
    K=length(u);
    pa1=zeros(K+2,1);
    pa2=zeros(K+2,1);
    pb=zeros(K+2,1);
    pc=zeros(K+2,1);
    y=[0;0;y];
    u=[0;0;u];
    yhat=zeros(K+2,1);
    E=zeros(K+2,1);
    
    
    for k=3:K+2
        % partial derivative 
        pa1(k)=-theta_hat(4)*pa1(k-1)-y(k-1);
        pa2(k)=-theta_hat(4)*pa2(k-1)-y(k-2);
        pb(k)=-theta_hat(4)*pb(k-1)+u(k-2);
        pc(k)=-theta_hat(4)*pc(k-1)+y(k-1)-yhat(k-1);
        % one step ahead prediction
        yhat(k)=(-theta_hat(1)+theta_hat(4))*y(k-1)-theta_hat(2)*y(k-2)+theta_hat(3)*u(k-2)-theta_hat(4)*yhat(k-1);
        % calculation of the residuals 
        E(k)=yhat(k)-y(k);
    end
    %Ignore time points k, k-1, k-2 in the following
    %Jacobian matrix (gradients)
    G=[pa1(3:end) pa2(3:end) pb(3:end) pc(3:end)];
    %Cost function
    J=0.5*E(3:end)'*E(3:end);
    %Residual
    E=E(3:end);
end