function mpc=design_mpc(model,rho,H_p,H_c,u_lb,u_ub,u_penalty)

%% Prepare matrices for MPC
mpc.H_s=model.d;
mpc.H_p=H_p;
mpc.H_c=H_c;
mpc.rho=rho;
mpc.u_lb=u_lb*ones(mpc.H_p-model.d+1,1);
mpc.u_ub=u_ub*ones(mpc.H_p-model.d+1,1);
mpc.Fm=[];mpc.Gm=[];mpc.Hm=[];mpc.Hdm=[];mpc.Gdm=[];

%%solution of Diophatine equations
for i=mpc.H_s:mpc.H_p
  [E_tmp,F_tmp]   = i_step_prediction(model.C,model.D,i);
  [G_tmp,H_tmp]   = i_step_prediction(model.B,model.A,i-model.d+1);
  [Gd_tmp,Hd_tmp] = i_step_prediction(model.Bd,model.Ad,i-model.dd);
  mpc.Fm(i-mpc.H_s+1,1:length(F_tmp)) = F_tmp;
  mpc.Gm(i-mpc.H_s+1,1:length(G_tmp)) = G_tmp(end:-1:1);
  mpc.Hm(i-mpc.H_s+1,1:length(H_tmp)) = H_tmp;
  mpc.Gdm(i-mpc.H_s+1,1:length(Gd_tmp)) = Gd_tmp(end:-1:1);
  mpc.Hdm(i-mpc.H_s+1,1:length(Hd_tmp)) = Hd_tmp;
end
%% u penalty 

if u_penalty=='delta'    
    %Matrices Phi and Omega - penalty for difference in u
    Tmp1=zeros(mpc.H_p-model.d+1,mpc.H_p-model.d+1);
    for i=2:mpc.H_p-model.d+1
      Tmp1(i,i-1)=-1;
    end
    mpc.Phi=eye(mpc.H_p-model.d+1,mpc.H_p-model.d+1)+Tmp1;
    Tmp2=zeros(mpc.H_p-model.d,1);
    mpc.Omega=[-1; Tmp2];
elseif u_penalty=='absolute'
    %penalty for absolute value of u
    mpc.Phi=eye(mpc.H_p-model.d+1,mpc.H_p-model.d+1);
    mpc.Omega=zeros(size(mpc.Omega));
else
    disp('u`_pentalty ?must be `delta ?or `absolute?!');
    return
end
%pendalty of highpass filtered u
%do to 

%% optimization; constraints in the form S*u=tt
mpc.S=[zeros(mpc.H_p-model.d-mpc.H_c+1,mpc.H_c-1) ... 
    ones(mpc.H_p-model.d-mpc.H_c+1,1) -eye(mpc.H_p-model.d-mpc.H_c+1, ...
    mpc.H_p-model.d-mpc.H_c+1)];
mpc.tt=zeros(mpc.H_p-model.d-mpc.H_c+1,1);

%%Initialisierung of MPC
mpc.LL=3*mpc.H_p;
past_u=ones(1,mpc.LL)*model.u0;
past_yf=ones(1,mpc.LL)*model.u0*sum(model.B)/sum(model.A);
past_p=ones(1,mpc.LL)*model.u0/sum(model.A);
past_o=ones(1,mpc.LL)*(model.y0-model.u0*sum(model.B)/sum(model.A))/sum(model.C);
past_y_yf=ones(1,mpc.LL)*model.y0-model.u0*sum(model.B)/sum(model.A);
past_ud=zeros(1,mpc.LL);
past_udf=zeros(1,mpc.LL);
past_yf_d=zeros(1,mpc.LL);
past_ud2=zeros(1,mpc.LL);
past_u2=past_u;
mpc.x_0=[past_u'; past_p'; past_o'; past_yf'; past_y_yf';past_ud';past_udf';past_yf_d';past_ud2';past_u2'];
end
