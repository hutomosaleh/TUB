function [Ei,Fi] = i_step_prediction(X,Y,i)
    %Solves the diophantine equation 
    %X(q^(-1))/Y(q^(-1))=E_i(q^(-1))+q^(-i)F_i(q^(-1))/Y(q^(-1))
    if (i<1)
        error('i must be equal or larger than 1');
    end
    if ((length(Y)-1)<1)
        error('Y must be a polynomial of degree 1 or larger');
    end
    if ((size(X,1)~=1)|(size(Y,1)~=1))
       error('X and Y must be row vectors coding polynomials');
    end
    %deg_Ei=i-1;
    deg_X=length(X)-1;
    deg_Y=length(Y)-1;
    deg_Fi=min([deg_X-i,deg_Y-1]);
    j=1;
    %E1=x0;
    Ei(1)=X(1);
    %F1=q(X-x0*Y)
    Fi=poly_add(X,-conv(X(1),Y));
    Fi=Fi(2:end);
    for j=2:i
        Ei(j)=Fi(1);
        Fi=poly_add(Fi(2:end),-Y(2:end)*Ei(j));
    end	
end
