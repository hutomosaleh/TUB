
function V_new = AHClimb(V_old, V_cur, S, T, C)
    I_old = PVmod(V_old, S, T);
    I_cur = PVmod(V_cur, S, T);
    
    P_old = I_old * V_old;
    P_cur = I_cur * V_cur;
    dP = abs(P_old - P_cur);
    dV = abs(V_old - V_cur);
    
    V_step = C * dP / dV;
    
    % Compare
    if P_cur > P_old
        V_new = V_cur + V_step;
    elseif P_cur < P_old
        V_new = V_cur - V_step;
    end
end