
function [D, V_new] = PVAHC(S, T, t_span, C)
    % Variables
    V_in = 1; % Start value
    V_out = 32;
    
    % Calculate Duty Cycle
    D = zeros(1, length(t_span));
    V_new = ones(1, length(t_span));
    
    for i = 1:length(t_span)
        D(i) = V_out ./ (V_in + V_out);
        if i == 1
            % Start values
            V_old = V_in;
            V_in = V_old + 1;
            V_new(i) = AHClimb(V_old, V_in, S, T, C);
            V_old = V_in;
        else
            V_in = V_new(i-1);
            V_new(i) = AHClimb(V_old, V_in, S, T, C);
            V_old = V_in;
        end
    end
end