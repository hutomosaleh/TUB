function [y,y_past_out,u_past_out]=filter_run(B,A,u,u_past,y_past);

if abs(A(1)-1)>1E-10
  return;
  disp('A must be monic');
end

if length(A)>1
  y=-A(2:length(A))*y_past(1:(length(A)-1))'+B*[u u_past(1:(length(B)-1))]';
else
  y=B*[u u_past(1:(length(B)-1))]';
end
y_past_out=[y y_past(1:end-1)];
u_past_out=[u u_past(1:end-1)];
end