function [Ei, Fi] = dio_gl(X, Y, i)
% Y ist monisch : Y = 1 + y_1q^-1 + ... + y_ny q^-ny
%
deg_X = length(X)-1;
deg_Y = length(Y)-1;
if(i~=1)
    % Grad E bestimmen
    if deg_Y>0
        deg_E = i-1;
    else
        deg_E = min([i-1, deg_X]);
    end

    % Grad F bestimmen
    deg_F = max([-i+deg_X, deg_Y-1]);
    
    [E_im1, F_im1] = dio_gl(X, Y, i-1);
    F_im1 = [F_im1, 0];    

    % Rekursive Aufruf
    Ei = [E_im1, F_im1(1)];
    Fi = zeros(1, deg_F+1);
    for i = 1:deg_F+1
        Fi(i) = F_im1(i+1)-Y(i+1)*F_im1(1);
    end
else
    Ei = X(1);
    if(length(X)>length(Y))
        X_erw = X;
        Y_erw = [Y, zeros(1,deg_X-deg_Y)];
    else
        Y_erw = Y;
        X_erw = [X, zeros(1,deg_Y-deg_X)];
    end
    Fi = zeros(1,length(X_erw)-1);
    for i=1:length(X_erw)-1
        Fi(i) = X_erw(i+1)-X_erw(1)*Y_erw(i+1);
    end
end