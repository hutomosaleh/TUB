close all
[model,params] = create_model();
%add disturbance model
c_pol=0.5;%schnell 0; super langsam 0.9<1
model.D=[1 -1];
model.C=[1 -c_pol];rho=0.01;
%c_pol=0.9;
%model.D=conv(model.Ad,[1 -1]);
%model.C=poly([c_pol c_pol c_pol c_pol]);
%c_pol=0.8;
%model.D=conv(model.Ad,1);
%model.C=poly([c_pol c_pol c_pol]);rho=0.0005;
%mpc=design_mpc(model,rho,H_p,H_c,u_lb,u_ub,u_penalty)
mpc=mpc_design(model,rho,60,20,model.u_lb,model.u_ub,'delta');
%mpc=mpc_design(model,rho,60,20,-10^10,+10^10,'delta');


%% Define meals and reference (deviation from 100mg/dl)
time_vec=[0:5:2000];
%ud meals
ud_vec=[0 0*ones(size(5:5:495)) 200 0*ones(size(505:5:2000))];
%reference
w_vec=[0 0*ones(size(5:5:795)) 30*ones(size(800:5:1200)) -30*ones(size(1205:5:2000))];

figure;
stairs(time_vec,ud_vec,'b','linewidth',1);hold on;stairs(time_vec,w_vec,'g--','linewidth',1.5);
xlabel('Zeit [min]');
ylabel('Eingangsgroessen');
legend('u_d','Detla w');