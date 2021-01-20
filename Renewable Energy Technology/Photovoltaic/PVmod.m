
function I = PVmod(V, S, T)
    %% Variables
    n = 72;  % Number of PV
    V = V / n;
    I_SC = 5.5;  % Short circuit current [A]
    k_o = 65e-3 / 100;  % Temp coeff of I_SC [%]
    S1 = 1;  % STC irradiance [kW / m^2]
    T = T + 273;  % Current Temperature [K]
    T1 = 25 + 273;  % STC temperature [K]
    q = 1.6e-19;  % Elementary charge [C]
    K = 1.381e-23;  % Boltzmann Constant
    gamma = 1.3;  % Diode Quality Factor
    
    V_G = 1.12;  % Band gap voltage
    V_OC = 44.8 / n;  % Open curcuit voltage
    
    R_S = 0.007;  % Resistance in series
    R_SH = 530;  % Resistance of shunt
    
    %% Calculate I_L
    if (S == S1)
        I_L = I_SC;
    else
        I_L = I_SC * (S / S1) * (1 + k_o * (T - T1));
    end
    
    %% Calculate I_S
    I_S1 = I_L / (exp((q * V_OC) / (gamma * K * T1)) - 1);
    I_S = I_S1 * (T / T1) ^ (3 / gamma) * exp((-q * V_G * (inv(T) - inv(T1))) / (gamma * K));

    %% Newton Iteration
    I = 0;  % Start value
    for i = 1:1:10  % 10 Iteration
        y = I_L - I ...
            - I_S * (exp(q * (V + I * R_S) / (gamma * K * T)) - 1) ...
            - (V + I * R_S) / R_SH;
        dy = -1 - (I_S * q * R_S / (gamma * K * T)) ...
             * exp(q * (V + I * R_S) / (gamma * K * T)) ...
             - R_S / R_SH;
        I = I - y ./ dy;
    end
end