function Z=poly_add(X,Y)
n_X=length(X);
n_Y=length(Y);
%make vectors equally long by adding zeros to the end
n=max(n_Y,n_X);
X=[X zeros(1,n-n_X)];
Y=[Y zeros(1,n-n_Y)];
Z=X+Y;
%remove possible ending zeros
while Z(end)==0
    Z(end)=[];
end
end