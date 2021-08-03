u=(0:10)';
K=length(u);
Theta1=0.5;Theta2=2;
y=Theta1*u+Theta2*u.^1.4+randn(K,1);%wahres System + Messrauschen
Phi=[u u.^1.4];
Theta_hat=Phi\y;
y_hat=Phi*Theta_hat;

figure(1); %Neues Figure mit Nummer 1
clf(1); %Löschen von bereits vorhandenem Figure-Inhalt
plot(u,y,'bx','MarkerSize',9,'linewidth',1.2);% Messungen
set(gca,'FontSize',15);%Set Default Fontsize 
                       %(gca – get handle to current axis)
hold on; %vorhandenen Figure-Inhalt ab hier nicht mehr löschen
plot(u,Theta1*u+Theta2*u.^1.4,'b','Linewidth',1.2); %wahres System M
plot(u,y_hat,'r','Linewidth',1.2); %geschätztes Modell N
l=legend('Messungen $y$','wahres System',...
    'gesch\"atztes Modell',...
    'location','nw','interpreter','latex');
l.FontSize = 15;
h=xlabel('$u$','interpreter','latex');
ylabel('Systemausgang','interpreter','latex');
title('LS Beispiel','interpreter','latex');
grid on;
%EPS vom Figure generieren
print -deps2c ls_example_plot1.eps
%Aufruf eines Systembefehls zum Umwandeln des EPS in ein PDF
!pstopdf ls_example_plot1.eps 
