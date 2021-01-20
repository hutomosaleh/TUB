
function V_new = HClimb(V_old, V_cur, V_step, S, T)
    I_old = PVmod(V_old, S, T);
    I_cur = PVmod(V_cur, S, T);
    
    P_old = I_old * V_old;
    P_cur = I_cur * V_cur;
    
    % Compare
    if P_cur > P_old
        V_new = V_cur + V_step;
    elseif P_cur < P_old
        V_new = V_cur - V_step;
    else
        V_new = V_cur;
    end
    
end
