clc;
clear;
close all;

Assignment_1();
Assignment_2();
Assignment_3();
Assignment_4();
Assignment_5();
Assignment_6();
Assignment_7();
Assignment_8();

%% 1. Assignment
function Assignment_1()
    %% Variables
    DOY = 37; % Day of the year, 6th of February 2020
    LT = (5:20);  % Local time, 5am to 20pm
    TZ = 7;  % Phuket time zone (UTF + 7)
    latitude = 7.878978;  % in degrees
    longitude = 98.398392;

    %% Plot
    [air_mass, sun_elevation, sun_azimuth] = SunDate(latitude, longitude, DOY, LT, TZ);
    figure(1);
    plot(sun_azimuth, sun_elevation, '-o');
    title('Phuket (7.878978, 98.398392) on 06.02.2020 (37/365)')
    ylabel('Altitude Position Ys in Degrees')
    xlabel('Azimuth As in Degrees')
end

%% 2. Assignment
function Assignment_2()
    %% Variables
    V = 0:0.01:44.8;
    I = PVmod(V, 1, 25);
    P = V .* I;

    %% Plot
    figure(2);
    title('Solar Module Performance & Data')
    xlim([0 50])
    grid on

    yyaxis left
    hold on
    plot(V, I, 'b', 'linewidth', 2)
    ylim([0 6])
    xlabel('Module Voltage [V]')
    ylabel('Module Current [A]')
    
    yyaxis right
    hold on
    plot(V, P, '--r', 'linewidth', 2)
    ylim([0 276])
    ylabel('Module Power [W]')
    
    %{
        By lowering the value of Rsh we will see a decrase in performance.
        In contrast, a decrease in performance will occur with higher value
        of Rs value.
    %}
    
    %% Effects of temperature and irradiance
    S_var = [0.3, 0.7, 1.3];
    T_var = [3, 21, 33];
    
    % Matrix preallocation
    N = length(T_var);
    I_1 = zeros(N, length(I));
    I_2 = zeros(N, length(I));
    P_1 = zeros(N, length(I));
    P_2 = zeros(N, length(I));
    for i=1:N
        I_1(i, :) = PVmod(V, 0.7, T_var(i)); % Fixed S, varying T
        P_1(i, :) = V .* I_1(i, :);
        I_2(i, :) = PVmod(V, S_var(i), 21); % Fixed T, varying S
        P_2(i, :) = V .* I_2(i, :);
    end

    figure(3);
    
    subplot(2,1,1)
    title('S = 0.7 (const)')
    grid on
    hold on
    plot(V, P_1(1, :), V, P_1(2, :), V, P_1(3, :), '--r', 'linewidth', 2)
    legend('T = 3', 'T = 21', 'T = 33');
    ylabel('Module Power [W]')
    xlabel('Module Voltage [V]')
    
    subplot(2,1,2)
    title('T = 21 (const)')
    grid on
    hold on
    plot(V, P_2(1, :), V, P_2(2, :), V, P_2(3, :), '--r', 'linewidth', 2)
    legend('S = 0.3', 'S = 0.7', 'S = 1.3');
    xlabel('Module Voltage [V]')
    ylabel('Module Power [W]')
    
    sgtitle('Solar Module Performance & Data')
    
    %{
        One of the problems of solar cell is to keep the temperature as low
        as possible. The formula also shows the dependency of T with the
        output I. Which shows that with increasing T, the V and therefore P
        decreases. This is supported with the result shown in Figure 3.
    
        By definition irradiance is the power per unit area received from
        the sun. It is therefore expected that with increasing irradiance,
        the power also increases. The result shown in the graph supports
        this hypothesis.
    %}
end

%% 3. Assignment
function Assignment_3()
    n = 72;
    R_S = 0.007;  % Resistance in series
    R_SH = 530;  % Resistance of shunt
    I_MPP = 5.1;
    V_MPP = 36.5 / n;
    V_OC = 44.8 / n;
    I_SC = 5.5;
    A = 1740e-3*1030e-3*32e-3;  % Area [m^3]
    S = 1;  % STC irradiance [kW / m^2]
    
    FF = V_MPP * I_MPP / (V_OC * I_SC);
    efficiency = V_MPP * I_MPP / (A * S);
    
    disp("Fill Factor: " + FF*100 + " %")
    disp("Efficiency: " + efficiency + " %")
end

%% 4. Assignment
function Assignment_4()
    %% Variables
    S = [330 330 710 710 1300 1300] * 1e-3;
    T = [0 25 0 25 0 25];
    V = 0:0.01:44.8;
    N = length(S);
    N2 = length(V);
    I = zeros(N, N2);
    P = zeros(N, N2);
    for i = 1:N
        I(i, :) = PVmod(V, S(i), T(i));
        P(i, :) = I(i, :) .* V;
    end
    
    % Get max P
    R_max = zeros(N, 1);
    for i = 1:N
        P_iter = 0;
        for j = 1:N2
            % If power decrease, Pmax is found
            if (P_iter > P(i, j))
                R_max(i) = V(1, j) / I(i, j);
                disp("Resistive load " + i + ": " + R_max(i));
                break
            end
            P_iter = P(i, j);
        end
    end
    
    %% Plot
    figure(4);
    for i = 1:N
        plot(V, P(i, :), '--', 'linewidth', 1)
        hold on
    end
    legend("1", "2", "3", "4", "5", "6")
    title('Solar Module Performance & Data')
    xlabel('Voltage [V]')
    ylabel('Power [W]')
    ylim([0 300])
    xlim([0 50])
    grid on
end

%% 5. Assignment
function Assignment_5()
    %% Variables
    R = [0 9 29 57 110];
    S = 1;
    T = 25;
    V = 0:0.01:44.8;
    nV = length(V);
    nR = length(R);
    I = PVmod(V, S, T);
    P = I .* V;
    load_index = zeros(nR, 1);
    
    % Get max P
    P_iter = 0;
    for j = 1:nV
        % If power decrease, Pmax is found
        if (P_iter > P(1, j))
            P_max = P(1, j); % Get maximum power
            R_ideal = V(1, j) / I(1, j);
            disp("Ideal load is: " + R_ideal + " Ohm")
            break
        end
        P_iter = P(1, j);
    end
    
    % Get index of equivalent V & I
    for i = 1:nR
        [~, load_index(i)] = min(abs(V./I - R(i)));
    end
    
    P_R = I(load_index).^2 .* R; % Calculate load power
    
    % Compare maximum power and calculate power loss
    P_loss = (P_max - P_R) ./ P_max .* 100;
    disp("Power loss (%) values are: ")
    disp(P_loss)
end

%% 6. Assignment
function Assignment_6()
    % S and T in standard condition
    S = 1; % [kW/m2]
    T = 25; % [C]
    
    V_step = 1;
    t_step = 1; % time step
    t_span = 0:t_step:2e2;
    [D, V_new] = PVHC(S, T, t_span, V_step);
    
    %% Plot
    figure(5);
    title('MPPT w/ PWM of a Buck-Boost Converter (V_{Ste} = 1V)')
    xlabel('Time steps [s]')
    
    yyaxis left
    hold on
    plot(t_span, D);
    ylabel('Duty Cycle')
    
    yyaxis right
    hold on
    plot(t_span, V_new);
    ylabel('Module operating voltage (v)')
    
    %{  
        The starting value of Vi could be any number, since the hill 
        climbing algorithm will near the value to the maximum power point.
        In our case, since a suitable starting point would be around but
        below the output voltage of 32V.
    %}
end

%% 7. Assignment
function Assignment_7()
    % S and T in standard condition
    S = 1; % [kW/m2]
    T = 25; % [C]
    
    V_step = 0.2;
    t_step = 1; % time step
    t_span = 0:t_step:2e2;
    [D, V_new] = PVHC(S, T, t_span, V_step);
    
    %% Plot
    figure(6);
    title('MPPT with small voltage change (V_{Step} = 0,2V)')
    xlabel('Time steps [s]')
    
    yyaxis left
    hold on
    plot(t_span, D);
    ylabel('Duty Cycle')
    
    yyaxis right
    hold on
    plot(t_span, V_new);
    ylabel('Module operating voltage (v)')
    
    %{  
        With smaller voltage change, the speed of convergence of the
        algorithm is slower and but the accuracy becomes better. This can
        be observed through the finer oscilation after reaching MPP.
    %}
end

%% 8. Assignment
function Assignment_8()
    % S and T in standard condition
    S = 1; % [kW/m2]
    T = 25; % [C]
    C = [0.2 0.6 1];
    
    t_step = 1; % time step
    t_span = 0:t_step:2e2;
    D = zeros(length(C), length(t_span));
    V_new = zeros(length(C), length(t_span));
    for i=1:length(C)
        [D(i, :), V_new(i, :)] = PVAHC(S, T, t_span, C(i));
    end
    
    %% Plot
    figure(7);
    
    subplot(311)
    title('C = 0.2')
    yyaxis left
    hold on
    plot(t_span, D(1, :));
    ylabel('Duty Cycle')
    yyaxis right
    hold on
    plot(t_span, V_new(1, :));
    xlabel('Time steps')
    ylabel('Voltage (v)')
    
    
    subplot(312)
    title('C = 0.6')
    yyaxis left
    hold on
    plot(t_span, D(2, :));
    ylabel('Duty Cycle')
    yyaxis right
    hold on
    plot(t_span, V_new(2, :));
    xlabel('Time steps')
    ylabel('Voltage (v)')
    
    subplot(313)
    title('C = 1')
    yyaxis left
    hold on
    plot(t_span, D(3, :));
    ylabel('Duty Cycle')
    yyaxis right
    hold on
    plot(t_span, V_new(3, :));
    xlabel('Time steps')
    ylabel('Voltage (v)')
    
    %{
        Varying C produces similar effect as varying the V_step directly.
        With smaller C value, the accuracy becomes better but the speed
        will become smaller. After a certain point, the V_step becomes too
        large and will lead to unexpected values. This is shown when C
        is equal to 1. The value does not converge to a stable value.
    %}
end