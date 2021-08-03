load model_bz;
time_vec=[0:5:1500];
u_vec=[0*ones(size(0:5:45)) 500*ones(size(50:5:145)) -300*ones(size(150:5:245)) 0*ones(size(250:5:1500))];
ud_vec=[200 0*ones(size(5:5:495)) 200 0*ones(size(505:5:1500))];

figure;
stairs(time_vec,u_vec,'r','linewidth',2);hold on;stairs(time_vec,ud_vec,'b','linewidth',1);
xlabel('Zeit [min]');
ylabel('Eingangsgroessen und Ausgang');

%solution
mpc.H_s=model.d;
mpc.H_p=300;

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


y_hat=mpc.Gm*u_vec(1:end-model.d)'+mpc.Gdm*ud_vec(2:end-model.dd)'+...
    mpc.Hdm*[ud_vec(1) 0 0]';
stairs(5*mpc.H_s:5:5*mpc.H_p,y_hat');hold on;stairs(time_vec',u_vec');
load sim_data.mat
plot(data(1,:),data(2:4,:));
legend('u','u_d','yhat (mpc)','yhat (sim)');