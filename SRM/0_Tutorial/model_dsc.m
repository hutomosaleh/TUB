function model_dsc(block)
% Level-2 MATLAB file S-Function 
% Discrete-time state-space model with u and 
% a (time-varying parameter) as inputs
  setup(block)
  
  
% endfunction

function setup(block)
  
% Register number of dialog parameters
  block.NumDialogPrms = 3; %Delta, z0, b
  %% Register number of input and output ports
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 2;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  %u(k)
  block.InputPort(1).Dimensions        = 1;
  block.InputPort(1).DirectFeedthrough = false;
  block.InputPort(1).SamplingMode='Sample'; 
  %a(k)
  block.InputPort(2).Dimensions        = 1;
  block.InputPort(2).DirectFeedthrough = false;
  block.InputPort(2).SamplingMode='Sample'; 
  %z(k)
  block.OutputPort(1).Dimensions       = 2;
  block.OutputPort(1).SamplingMode='Sample'; 
  %y(k)
  block.OutputPort(2).Dimensions       = 1;
  block.OutputPort(2).SamplingMode='Sample'; 
  
  %% Set block sample time to inherited
  Delta=block.DialogPrm(1).data;
  block.SampleTimes = [Delta 0];
  
  %% Set the block simStateCompliance to default 
  %% (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
  block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Update',                  @Update);  
  
%endfunction

function DoPostPropSetup(block)

  %% Setup Dwork
  %state z
  block.NumDworks = 1;
  block.Dwork(1).Name = 'z'; 
  block.Dwork(1).Dimensions      = 2;
  block.Dwork(1).DatatypeID      = 0;
  block.Dwork(1).Complexity      = 'Real';
  block.Dwork(1).UsedAsDiscState = true;

%endfunction

function InitConditions(block)

  %% Initialize Dwork
  %set z(0)
  z_0=block.DialogPrm(2).data;
  block.Dwork(1).Data = z_0;
  
%endfunction

function Output(block)
  %calculate y(k)  
  z1_k=block.Dwork(1).Data(1);
  z2_k=block.Dwork(1).Data(2);
  block.OutputPort(1).Data = block.Dwork(1).Data;
  block.OutputPort(2).Data = 0.6*z1_k+0.2*z2_k+0.4*randn(1);
  
%endfunction

function Update(block)
  %calculate z(k+1) and store it  
  z1_k=block.Dwork(1).Data(1);
  z2_k=block.Dwork(1).Data(2);
  b = block.DialogPrm(3).data;
  u_k=block.InputPort(1).Data;
  a_k=block.InputPort(2).Data;
  z1_kp1=0.4*z1_k+0.2*z2_k;
  z2_kp1=b*z1_k+a_k*z2_k+u_k;
  block.Dwork(1).Data = [z1_kp1;z2_kp1];
