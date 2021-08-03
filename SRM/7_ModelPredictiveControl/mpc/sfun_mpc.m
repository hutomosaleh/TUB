function sfun_mpc(block)
% 
% Author: Thomas Schauer

setup(block);
%endfunction

function setup(block)
  % Register number of dialog parameters
  block.NumDialogPrms  = 2;
  % Register number of input and output ports
  block.NumInputPorts  = 6;%w,y,u_km1,ud,ud_kmin1,
  block.NumOutputPorts = 4;%u(k),[yhat(H_s),y_hat(H_p)],yhat_vec,u_hat_opt
  % Setup functional port properties to dynamically be inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  block.InputPort(1).Dimensions        = 1;
  block.InputPort(1).DirectFeedthrough = true;
  block.InputPort(1).SamplingMode='Sample'; 
  
  block.InputPort(2).Dimensions        = 1;
  block.InputPort(2).DirectFeedthrough = true;
  block.InputPort(2).SamplingMode='Sample'; 

  block.InputPort(3).Dimensions        = 1;
  block.InputPort(3).DirectFeedthrough = true;
  block.InputPort(3).SamplingMode='Sample'; 

  block.InputPort(4).Dimensions        = 1;
  block.InputPort(4).DirectFeedthrough = true;
  block.InputPort(4).SamplingMode='Sample'; 

  block.InputPort(5).Dimensions        = 1;
  block.InputPort(5).DirectFeedthrough = true;
  block.InputPort(5).SamplingMode='Sample'; 

  block.InputPort(6).Dimensions        = 1;
  block.InputPort(6).DirectFeedthrough = true;
  block.InputPort(6).SamplingMode='Sample'; 

  block.OutputPort(1).Dimensions       = 1;
  block.OutputPort(1).SamplingMode='Sample'; 
  block.OutputPort(2).Dimensions       = 2;
  block.OutputPort(2).SamplingMode='Sample'; 
  mpc=block.DialogPrm(1).Data;
  model=block.DialogPrm(2).Data;
  
  block.OutputPort(3).Dimensions       = mpc.H_p-mpc.H_s+1;
  block.OutputPort(3).SamplingMode='Sample'; 
  block.OutputPort(4).Dimensions       = mpc.H_p-mpc.H_s+1;
  block.OutputPort(4).SamplingMode='Sample'; 
  
  % Set block sample time 
  block.SampleTimes = [model.Ts 0];
  % Setup Dwork
  %block.NumContStates = length(params.x_0);
  % Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';
  % Register block methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions);
  block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('Outputs',                 @Output);
  block.RegBlockMethod('Update',                  @Update);
  %block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
%endfunction

function DoPostPropSetup(block)
  mpc=block.DialogPrm(1).Data;
  model=block.DialogPrm(2).Data;
  %% Setup Dwork
  block.NumDworks = 1;
  block.Dwork(1).Name = 'z0'; 
  block.Dwork(1).Dimensions      = length(mpc.x_0);
  block.Dwork(1).DatatypeID      = 0;
  block.Dwork(1).Complexity      = 'Real';
  block.Dwork(1).UsedAsDiscState = true;
%endfunction


function InitConditions(block)
  % Initialize Dwork
  mpc=block.DialogPrm(1).Data;
  model=block.DialogPrm(2).Data;
  block.Dwork(1).Data = mpc.x_0;
%endfunction

function Output(block)
%get mpc
  mpc=block.DialogPrm(1).Data;
  model=block.DialogPrm(2).Data;
  %get inputs 
  r=block.InputPort(1).Data*ones(mpc.H_p,1);
  y=block.InputPort(2).Data;
  u_kmin1=block.InputPort(3).Data;
  u_kmind=block.InputPort(4).Data;
  ud=block.InputPort(5).Data;
  ud_kmind=block.InputPort(6).Data;
  %get states
  z=block.Dwork(1).Data;
  past_u=z(1:mpc.LL)';
  past_p=z(mpc.LL+1:2*mpc.LL)';
  past_o=z(2*mpc.LL+1:3*mpc.LL)';
  past_yf=z(3*mpc.LL+1:4*mpc.LL)';
  past_y_yf=z(4*mpc.LL+1:5*mpc.LL)';
  past_ud=z(5*mpc.LL+1:6*mpc.LL)';
  past_udf=z(6*mpc.LL+1:7*mpc.LL)';
  past_yf_d=z(7*mpc.LL+1:8*mpc.LL)';
  past_ud2=z(8*mpc.LL+1:9*mpc.LL)';
  past_u2=z(9*mpc.LL+1:10*mpc.LL)';
  
  Ld=length(model.D)-1;
  La=length(model.A)-1;
  Lad=length(model.Ad)-1;

  [yf,past_yf,pastu2] = filter_run(model.B,model.A,u_kmind,past_u2,past_yf);
  [yf_d, past_yf_d,past_ud2] = filter_run(model.Bd,model.Ad,ud_kmind,past_ud2,past_yf_d);
  [o, past_o, past_y_yf] = filter_run(1,model.C,(y-(yf+yf_d)),past_y_yf,past_o);
  [p, past_p, past_u] = filter_run(1,model.A,u_kmin1,past_u,past_p);
  [udf, past_udf, past_ud] = filter_run(1,model.Ad,ud,past_ud,past_udf);
  
  Q=2*(mpc.Gm'*mpc.Gm+mpc.rho*mpc.Phi'*mpc.Phi);
  p_t=2*((mpc.Hm*past_p(1:(La))'+mpc.Fm*past_o(1:(Ld))'+...
      mpc.Hdm*past_udf(1:(Lad))'-r(1:mpc.H_p-model.d+1))'*mpc.Gm+mpc.rho*u_kmin1*mpc.Omega'*mpc.Phi);
  [u_hat_opt] = quadprog(Q,p_t',[],[],mpc.S,mpc.tt,mpc.u_lb,mpc.u_ub,[],optimoptions('quadprog','Display','off'));
  
  y_hat=mpc.Gm*u_hat_opt+mpc.Hm*past_p(1:La)'+mpc.Fm*past_o(1:Ld)'+mpc.Hdm*past_udf(1:(Lad))';
  block.OutputPort(1).Data = u_hat_opt(1);
  block.OutputPort(2).Data(1) = y_hat(1);%y_hat(k+H_s)=y_hat(k+5)
  block.OutputPort(2).Data(2) = y_hat(mpc.H_p-mpc.H_s);%y_hat(k+H_p)
  block.OutputPort(3).Data = y_hat;
  block.OutputPort(4).Data = u_hat_opt;
%endfunction

function Update(block)
  mpc=block.DialogPrm(1).Data;
  model=block.DialogPrm(2).Data;
  %get inputs 
  r=block.InputPort(1).Data*ones(mpc.H_p,1);
  y=block.InputPort(2).Data;
  u_kmin1=block.InputPort(3).Data;
  u_kmind=block.InputPort(4).Data;
  ud=block.InputPort(5).Data;
  ud_kmind=block.InputPort(6).Data;
  
  %get states
  z=block.Dwork(1).Data;
  past_u=z(1:mpc.LL)';
  past_p=z(mpc.LL+1:2*mpc.LL)';
  past_o=z(2*mpc.LL+1:3*mpc.LL)';
  past_yf=z(3*mpc.LL+1:4*mpc.LL)';
  past_y_yf=z(4*mpc.LL+1:5*mpc.LL)';
  past_ud=z(5*mpc.LL+1:6*mpc.LL)';
  past_udf=z(6*mpc.LL+1:7*mpc.LL)';
  past_yf_d=z(7*mpc.LL+1:8*mpc.LL)';
  past_ud2=z(8*mpc.LL+1:9*mpc.LL)';
  past_u2=z(9*mpc.LL+1:10*mpc.LL)';
   
  Ld=length(model.D)-1;
  La=length(model.A)-1;
  Lad=length(model.Ad)-1;

  %[yf,past_yf,tmpxxx] = filter_run(model.B,model.A,u_kmin1,past_u,past_yf);%TS order exchanged
  [yf,past_yf,past_u2] = filter_run(model.B,model.A,u_kmind,past_u2,past_yf);%TS order exchanged
  [yf_d, past_yf_d,past_ud2] = filter_run(model.Bd,model.Ad,ud_kmind,past_ud2,past_yf_d);
  %[yf_d, past_yf_d,past_ud2] = filter_run(model.Bd,model.Ad,ud_kmin1,past_ud2,past_yf_d);
  [o, past_o, past_y_yf] = filter_run(1,model.C,(y-(yf+yf_d)),past_y_yf,past_o);
  [p, past_p, past_u] = filter_run(1,model.A,u_kmin1,past_u,past_p);
  [udf, past_udf, past_ud] = filter_run(1,model.Ad,ud,past_ud,past_udf);
  
  Q=2*(mpc.Gm'*mpc.Gm+mpc.rho*mpc.Phi'*mpc.Phi);
  p_t=2*((mpc.Hm*past_p(1:(La))'+mpc.Fm*past_o(1:(Ld))'+...
      mpc.Hdm*past_udf(1:(Lad))'-r(1:mpc.H_p-model.d+1))'*mpc.Gm+mpc.rho*u_kmin1*mpc.Omega'*mpc.Phi);
  [u_hat_opt] = quadprog(Q,p_t',[],[],mpc.S,mpc.tt,mpc.u_lb,mpc.u_ub,[],optimoptions('quadprog','Display','off'));
  %y_hat=mpc.Gm*u_hat_opt+mpc.Hm*past_p(1:La)'+mpc.Fm*past_o(1:Ld)'+mpc.Hdm*past_udf(1:(Lad))';
  %disp(u_hat_opt);
  %update states
  block.Dwork(1).Data=[past_u'; past_p'; past_o'; past_yf'; past_y_yf';past_ud';past_udf';past_yf_d'; past_ud2';past_u2'];
%endfunction
