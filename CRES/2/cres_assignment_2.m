clc
clear
close all

% %% change_tau_value(tau_start, tau_end, tau_increment, lambda, start_value, figure_name)
% change_tau_value(0.001, 100, 0.001, -1, 1, '\tau from 0.001 to 100 (Default)');
% change_tau_value(0.001, 100, 0.001, -1, 1000, 'Large initial condition x0');
% change_tau_value(0.001, 100, 0.001, -10, 1, 'Large lambda \lambda');
% change_tau_value(0.001, 100, 0.001, 3, 1, 'Positive lambda \lambda');

%% Loop through tau, initial & lambda values
change_tau_value(0.001, 100, 0.001, -10, 1, '\tau from 0.001 to 100 (Default, t_max = 1)');
change_initial_value(1, 100, 1, -1, 0.01, 'x0 from 1 to 100 (\tau = 0.01)');
change_lambda(-10, 10, 1, 1, 0.01, '\lambda from -10 to 10 (\tau = 0.01)');
change_initial_value(1, 100, 1, -1, 2, 'x0 from 1 to 100 (\tau = 2)');
change_lambda(-10, 10, 1, 1, 2, '\lambda from -10 to 10 (\tau = 2)');
change_initial_value(1, 100, 1, -1, 10, 'x0 from 1 to 100 (\tau = 10)');
change_lambda(-10, 10, 1, 1, 10, '\lambda from -10 to 10 (\tau = 10)');


function change_tau_value(tau_start, tau_end, increment, lambda, y0, name)
    %% Calculate
    result = zeros(1, tau_end / increment);  % For Y-Axis values
    x_value = result;  % For X-Axis values
    i = 1;  % Index for inserting into the matrix
    for h = tau_start:increment:tau_end
        result(i) = trapezoidal(h, lambda, y0);
        x_value(i) = h;  % Put tau value for X-Axis range
        i = i + 1;
    end
    
    %% Plot
    figure('name', name)
    plot(x_value, result(1, :));  % Plot it
    title(name); % Name the window
    y_limit = result(1, 1);  % Define the limits
    ylim([-y_limit y_limit]);  % Set the Y-Axis range
    ylabel("Output")  % Set Axis labels
    xlabel("Step size")
end

function change_initial_value(y0_start, y0_end, increment, lambda, tau, name)
    %% Calculate
    result = zeros(1, y0_end / increment);  % For Y-Axis values
    x_value = result;  % For X-Axis values
    i = 1;  % Index for inserting into the matrix
    for y0 = y0_start:increment:y0_end
        result(i) = trapezoidal(tau, lambda, y0);
        x_value(i) = y0;  % Put tau value for X-Axis range
        i = i + 1;
    end
    
    %% Plot
    figure('name', name)
    plot(x_value, result(1, :));  % Plot it
    title(name); % Name the window
    xlim([1 100]);  % Set the Y-Axis range
    ylabel("Output")  % Set Axis labels
    xlabel("Initial Value")
end

function change_lambda(lambda_start, lambda_end, increment, y0, tau, name)
    %% Calculate
    result = zeros(1, lambda_end / increment);  % For Y-Axis values
    x_value = result;  % For X-Axis values
    i = 1;  % Index for inserting into the matrix
    for lambda = lambda_start:increment:lambda_end
        result(i) = trapezoidal(tau, lambda, y0);
        x_value(i) = lambda;  % Put tau value for X-Axis range
        i = i + 1;
    end
    
    %% Plot
    figure('name', name)
    plot(x_value, result(1, :));  % Plot it
    title(name); % Name the window
    xlim([-10 10]);  % Set the Y-Axis range
    ylabel("Output")  % Set Axis labels
    xlabel("Lambda")
end

function y = trapezoidal(tau, lambda, y0)
    t_max = 1;
    k = t_max / tau;
    y = ((1 + 0.5 * tau * lambda) / (1 - 0.5 * tau * lambda))^k * y0;
end

function y = forward_euler(h, k, y0, t_max)
    n = t_max / h;
    z = h * k;
    y = (1 + z)^n * y0;
end

%% Forward Euler

% change_tau_value(0.001, 0.01, 0.001, -1, 1, 'Forward Euler')
% forward_euler(0.01, -1, 1, 1);
%         result(i) = forward_euler(h, k, y0, 1);
    
%% Source
% https://en.wikipedia.org/wiki/Stiff_equation#A-stability
% https://en.wikipedia.org/wiki/Trapezoidal_rule_(differential_equations)