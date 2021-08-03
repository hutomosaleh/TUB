load model_bz;
time_vec=[0:5:1500];
u_vec=[0*ones(size(0:5:45)) 500*ones(size(50:5:145)) -300*ones(size(150:5:245)) 0*ones(size(250:5:1500))];
ud_vec=[200 0*ones(size(5:5:495)) 200 0*ones(size(505:5:1500))];

figure;
stairs(time_vec,u_vec,'r','linewidth',2);hold on;stairs(time_vec,ud_vec,'b','linewidth',1);
xlabel('Zeit [min]');
ylabel('Eingangsgroessen');
legend('u','u_d');

return

%solution

figure;
stairs(time_vec,u_vec,'r','linewidth',2);hold on;stairs(time_vec,ud_vec,'b','linewidth',1);
xlabel('Zeit [min]');
ylabel('Eingangsgroessen');
legend('u','u_d');
return
y_hat=mpc.Gm*u_vec(1:end-model.d)'+mpc.Gdm*ud_vec(2:end-model.dd)'+...
    mpc.Hdm*[ud_vec(1) 0 0]';
figure();stairs(25:5:500,y_hat');hold on;stairs(time_vec',u_vec');
stairs(time_vec',ud_vec');
load sim_data.mat
plot(data(1,:),data(2:4,:));