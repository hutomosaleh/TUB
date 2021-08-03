function hiv_model(block)
% Level-2 MATLAB file S-Function for HIV-1 Model form (Souza, 1999).

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of dialog parameters   
  block.NumDialogPrms = 3; %xdash_init & theta_vec & xdash12_RL

  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = [1,1];
  block.InputPort(1).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = [3,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 3;

  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Derivatives',             @Derivative);  
  
%endfunction

function InitConditions(block)

  %% Initialize Dwork
  block.ContStates.Data = block.DialogPrm(1).Data;
  
%endfunction

function Output(block)

  block.OutputPort(1).Data = block.ContStates.Data;
  
%endfunction

function Derivative(block)

     u =  block.InputPort(1).Data;
   
     Theta = block.DialogPrm(2).Data;
     xdash12RL = block.DialogPrm(3).Data;
     xdash=block.ContStates.Data;
     if (block.CurrentTime>5)
         Theta(2)=40;
     end
     xdashdot=[-Theta(1)*xdash(1)-Theta(2)*xdash(1)*xdash(3)+...
         Theta(1)*xdash12RL(1);
           -Theta(3)*xdash(2)+Theta(4)*xdash(2)*xdash(3)+...
           Theta(3)*xdash12RL(2);
           Theta(5)*xdash(1)*xdash(3)-Theta(6)*xdash(2)*xdash(3)-u];
     block.Derivatives.Data = xdashdot;
  
%endfunction