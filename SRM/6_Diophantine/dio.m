function [Ei, Fi] = dio(X, Y, i)
    syms q q_1
    if isnumeric(Y)
        Y_sym = 0;
        for k=1:length(Y)
            Y_sym = Y_sym + Y(k)*q_1^(k-1);
        end
        Y = Y_sym;
    end
    if isnumeric(X)
        if length(X)==1
            x = X;
        else
            X_sym = 0;
            for k=1:length(X)
                X_sym = X_sym + X(k)*q_1^(k-1);
            end
            X = X_sym;
        end
    else
        x = coeffs(X); % Polynome zu Matrizen
    end
    E_j = x(1);
    F_j = q*(X-x(1)*Y);
    j = 1;
    
    while j~=i
        f = coeffs(F_j);  % Polynome zu Matrizen
        e_j1 = f(1);
        E_j1 = E_j + e_j1*q_1;
        F_j1 = q * (F_j - Y*f(1));
        j = j+1;
        
        E_j = E_j1;
        F_j = F_j1;
    end

    F_j = matlabFunction(F_j);  % q mit 1/q_1 ersetzen
    Ei = E_j;
    Fi = F_j(1/q_1, q_1);
    
    if ~isnumeric(Ei)
        Ei = simplify(Ei);
        Ei = coeffs(Ei);
    end
    if ~isnumeric(Fi)
        Fi = simplify(Fi);
        Fi = coeffs(Fi);
    end
    
end