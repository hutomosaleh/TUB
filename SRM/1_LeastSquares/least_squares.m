clc
clear
close all

for i = 1:2
    if i==1
        d = load("data_0_9.txt");
        intervall = 9;
    else
        d = load("data_0_6.txt");
        intervall = 6;
    end
    
    u = d(:, 1);
    y = d(:, 2);
    K = length(u);
    u_mess = u;
    Phi_mess = [u_mess.^2 sin(3*u_mess) u_mess ones(K, 1)];
    u = linspace(0, intervall, K)';
    Phi_neu = [u.^2 sin(3*u) u ones(K, 1)];
    u = linspace(-3, 15, K)';
    Phi = [u.^2 sin(3*u) u ones(K, 1)];
    Theta_hat = Phi_mess \ y;
    y_hat = Phi * Theta_hat;

    % Mit Angabe des 95%-Konfidenzintervalls
    I = length(Theta_hat);
    sigma_r = (y - Phi*Theta_hat)' * (y-Phi*Theta_hat) / (K-I);
    Pident = (Phi_mess'*Phi_mess)^-1 * sigma_r;
    P_yhat = Phi_neu * Pident * Phi_neu';
    P_diag = diag(P_yhat);
    Varianz = 1.96*sqrt(P_diag);
    y_max = y_hat + Varianz;
    y_min = y_hat - Varianz;


    % Wahres System
    y_wahr = 0.3*u.^2 + 2*sin(3*u) + 0.5*u + 2;

    % Plot
    figure("name", "Aufgabe " + int2str(i));
    plot(u_mess, y, 'bx', 'MarkerSize', 6, 'linewidth', 1.2);
    hold on;
    plot(u, y_wahr, 'b', 'linewidth', 1.2);
    plot(u, y_hat, 'g', 'Linewidth', 1.2);
    plot(u, y_max, 'm--', 'Linewidth', 1.2);
    plot(u, y_min, 'r--', 'Linewidth', 1.2);
    l=legend('Messungen y','wahres System', 'geschaetztes Modell', ...
             'Lin-max Regression', 'Lin-min Regression');
    l.FontSize = 15;
    xlabel('u');
    ylabel('Systemausgang');
    title("Lineare Regression von Datensatz " + int2str(i));
    grid on;
end