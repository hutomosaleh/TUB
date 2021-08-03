
function [D, V_new] = PVHC(S, T, t_span, V_step)
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
            V_new(i) = HClimb(V_old, V_in, V_step, S, T);
            V_old = V_in;
        else
            V_in = V_new(i-1);
            V_new(i) = HClimb(V_old, V_in, V_step, S, T);
            V_old = V_in;
        end
    end
end