function varargout = std_ident(identData)
%% Initial-Parameter (Kein Einfluss auf die Identifikationen)
persistent r_p c_p r_s
if isempty(r_p)
    r_p = 2.7e3;    %Parallel-Widerstand [Ohm]
end
if isempty(c_p)
    c_p = 2.2e-7;   %Parallel-Kondensator [Farrad]
end
if isempty(r_s)
    r_s = 470;      %Serien-Widerstand [Ohm]
end       

%% Transfer-Funktion

odefun = 'einf_haut_impedanz';  %alle Parameter von einf_haut_impedanz wurde
                                %schon am Anfang definiert
parameter = {'Serien Widerstand', r_s; 'Parallel-Widerstand', r_p;
    'Parallel-Kondensator', c_p};
fcn_type = 'c';
greybox = idgrey(odefun, parameter, fcn_type);
greybox.Structure.Parameters(1).Minimum = 0;  %r_s muss positiv
greybox.Structure.Parameters(2).Minimum = 0;  %auch r_p
greybox.Structure.Parameters(3).Minimum = 0;  %und c_p
greybox.Structure.Parameters(3).Maximum = 0.1;

%% Zusammenarbeit mit der Batchsimulation


if isa(identData, 'iddata')
    t = identData.SamplingInstants;
    i_skin = identData.u;
    v_skin = identData.y;
else
    t = identData.time-identData.time(1);
    i_skin = identData.stimCurrent/1000;
    v_skin = identData.stimVoltage;
end
    
start = 1;
est_param = [];
p = [1];
while(~isnan(p))
    i_amp = median(i_skin(i_skin>max(i_skin)*0.5));
    
    [p, start] = check_pulse_batch(i_skin,i_amp,v_skin,t,start,greybox);
    if(~isnan(p))
        est_param = [est_param p];
    end
end

if isempty(est_param)
        Rs = NaN; Rp = NaN; Cp = NaN; fit = NaN;
    if isa(identData, 'iddata')
        varargout{1} = fit;
        varargout{2} = [Rs, Rp, Cp];
    else
        model = struct('Rs', Rs, 'Rp', Rp, 'Cp', Cp);
       model.isValid = false;
       varargout{1} = model;
       identData.model = model;
       varargout{2} = identData;
    end 
    return
else
    Rs = mean(est_param(1,:));
    Rp = mean(est_param(2,:));
    Cp = mean(est_param(3,:));
    stdv = struct('Rs',std(Rs),'Rp',std(Rp),'Cp',std(Cp));
end
r_s = Rs; r_p = Rp; c_p = Cp;

%% Ergebnis ausgeben
if isa(identData, 'iddata')
    % Estimierte Parameter nochmal simulieren
    A = [-1/Rp/Cp]; B = [1/Cp]; C = [1]; D = [Rs];
    est_sys = tf(ss(A,B,C,D));
    v_est = lsim(est_sys,i_skin,t);
    fit = goodnessOfFit(v_est,v_skin,'MSE');

    % a = v_skin/(max(v_skin)*10);
    figure(); hold on; grid on;
    plot(t/1e6,v_skin, 'b', 'LineWidth', 1);
    plot(t/1e6,v_est, 'r--');
    %plot(t/1e6, a, 'g');
    hold off
    %legend('Error U', 'Verlauf U');
    legend('Actual U', 'Estimated U');
    ylabel('Voltage [V]'); xlabel('Time[us]');

    varargout{1} = fit;
    varargout{2} = [Rs Rp Cp];
    varargout{3} = stdv;
else
   model = struct('Rs', Rs, 'Rp', Rp, 'Cp', Cp);
   model.isValid = true;
   varargout{1} = model;
   identData.model = model;
   varargout{2} = identData;
end
end

