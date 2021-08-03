function [t,u]=prbs(N,p,n,Ts,Mean,Amp)

%N - order (from 2 to 10)
%p - frequency divider (integer)
%Ts - Sampling time
%n - number of repetitions
%Mean
%Amp

if (N == 9)
  feedback_bits=[2 3 4 8];
  nofb=4;
else
  feedback_bits_vec=[0 0;
                     1 2;
                     1 3;
                     3 4;
                     3 5;
                     5 6;
                     4 7;
                     2 8;
                     0 0;
                    7 10;];
  feedback_bits=feedback_bits_vec(N,:);
  nofb=2;
end

shift_register=ones(1,N);
prbs_raw=[];

for i=1:(2^N-1)
  prbs_raw(i)=shift_register(end);
  temp_shift_register=mod(sum(shift_register(feedback_bits)),2);
  shift_register(2:end)=shift_register(1:end-1);
  shift_register(1)=temp_shift_register;
end

t=((1:(2^N-1)*p*n)-1)*Ts;
u=(prbs_raw-0.5)*2*Amp+Mean;

uu=[];
for i=1:2^N-1
  uu=[uu ones(1,p)*u(i)];
end

u=[];
for i=1:n
  u=[u uu];
end

end
