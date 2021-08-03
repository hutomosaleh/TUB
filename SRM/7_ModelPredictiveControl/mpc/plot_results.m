
load MPC_Test
t=MPC_data(8,:)';
r=MPC_data(9,:)';
y=MPC_data(3,:)';
y_n=MPC_data(2,:)';
x1=MPC_data(4,:)';
u1=MPC_data(6,:)';
u2=MPC_data(7,:)';
u3=MPC_data(5,:)';
u=MPC_data(10,:)';
yhat_15=MPC_data(11,:)';
close all
figure;
subplot(2,1,1);
plot(t,100+x1);hold;
plot(t,100+y_n,'x');
plot(t,100+r,'r');
plot(t,100+ones(size(r))-30,'b--');
plot(t,100+ones(size(r))+70,'b--');


%plot([500/60 500/60],[50 200],'g','linewidth',4);
ylabel('Glucose conc. [mg/dl]');
legend('real glucose conc.','measured','reference', 'lower limit', 'upper limit','meal (ca. 80g carbohydrates)');

subplot(2,1,2)

stairs(t,u);hold on;
stairs(t,ones(size(t))*800,'k--');
stairs(t,-ones(size(t))*1000,'b--');
legend('control signal u','constraints');
xlabel('Time [h]');
ylabel('u'); 
