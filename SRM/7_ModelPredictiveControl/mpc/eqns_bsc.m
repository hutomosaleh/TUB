function y=eqns_bsc(x,params)
  y(1)=-(params.S_G+x(2)-x(3))*x(1)+params.S_G*params.G_B+x(5)/params.V;         %equation 12
  y(2)=-params.p2*x(2)+params.p2*params.S_I*(x(6)-params.I_B);                   %equation 2
  y(3)=-params.p3*x(3)+params.p3*params.S_N*(x(9)-params.N_B);                   %equation 7
  y(4)=(1/params.tmax_G)*(-x(4)+params.A_G*params.u3_R);                    %equation 10
  y(5)=(1/params.tmax_G)*(-x(5)+x(4));                      %equation 11
  y(6)=-params.ke*x(6)+x(8)/(params.V_I*params.tmax_I);                   %equation 13
  y(7)=x(12)-x(7)/params.tmax_I;                            %equation 14
  y(8)=(x(7)-x(8))/params.tmax_I;                           %equation 15
  y(9)=-params.kn*x(9)+x(11)/(params.V_N*params.tmax_N);                  %equation 16
  y(10)=params.u2_R-x(10)/params.tmax_N;                           %equation 17
  y(11)=(x(10)-x(11))/params.tmax_N; %equation 18
  y(12)=x(1)-params.x1_R;  
end