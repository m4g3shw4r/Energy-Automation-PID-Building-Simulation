% Energy Management Using Control Systems Automation
% Mini Project: Building Automation for Lighting and HVAC with feedback control
% Includes Energy Consumption Calculations and Reports

clc; clear; close all;

%% Parameters
time_hours = 24;                    % Simulate for 24 hours
ambient_temperature = 30;           % Ambient temperature (°C)
desired_temp = 22;                  % Desired room temperature (°C)

% Occupancy pattern for 24 hours
occupancy = [1 1 1 1 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 1 1 1 1];

lighting_power_max = 100;           % Max lighting power (W)
hvac_power_max = 1500;              % Max HVAC power (W)

% Improved PID gains
Kp = 20;
Ki = 5;
Kd = 2;

%% Initial conditions
room_temp = ambient_temperature;
integral_error = 0;
prev_error = 0;

%% Arrays to store results
lighting_power = zeros(1, time_hours);
hvac_power = zeros(1, time_hours);
room_temp_trace = zeros(1, time_hours);

%% Control Loop Simulation (hourly steps)
for t = 1:time_hours

    % ----- Lighting control -----
    lighting_power(t) = lighting_power_max * occupancy(t);

    % ----- HVAC PID-Based Temperature Control -----
    if occupancy(t) == 1

        % PID calculations
        error = desired_temp - room_temp;
        integral_error = integral_error + error;
        derivative_error = error - prev_error;

        control_signal = Kp*error + Ki*integral_error + Kd*derivative_error;

        % Bound output
        control_signal = max(0, min(hvac_power_max, control_signal));

        hvac_power(t) = control_signal;

        % Improved thermal dynamics
        cooling_effect = (hvac_power(t)/hvac_power_max) * 2;  % max 2°C cooling per hour
        room_temp = room_temp + 0.3*(ambient_temperature - room_temp) - cooling_effect;

        prev_error = error;

    else
        % no occupancy → HVAC OFF
        hvac_power(t) = 0;
        room_temp = room_temp + 0.3*(ambient_temperature - room_temp);

        % Reset controller
        integral_error = 0;
        prev_error = 0;
    end

    % store temp
    room_temp_trace(t) = room_temp;

end

%% ----- ENERGY CALCULATIONS -----
lighting_energy_kwh = sum(lighting_power)/1000;   % kWh
hvac_energy_kwh = sum(hvac_power)/1000;           % kWh

total_energy_kwh = lighting_energy_kwh + hvac_energy_kwh;

% Energy cost in India average 8 ₹ per unit (kWh)
unit_cost = 8;
total_cost = total_energy_kwh * unit_cost;

%% ----- Plot Results -----
time_axis = 1:time_hours;

figure;

% ----- 1. Occupancy -----
subplot(4,1,1);
stairs(time_axis, occupancy,'LineWidth',2);
ylim([-0.2 1.2]);
ylabel('Occupancy');
title('Occupancy (1 = Occupied)');
grid on;

% ----- 2. Lighting Power -----
subplot(4,1,2);
plot(time_axis, lighting_power, 'r', 'LineWidth',2);
ylabel('Lighting Power (W)');
title('Lighting Power Consumption');
grid on;

% ----- 3. HVAC Power and Room Temp (Dual Axis) -----
subplot(4,1,3);

yyaxis left
plot(time_axis, hvac_power, 'b', 'LineWidth',2);
ylabel('HVAC Power (W)');

yyaxis right
plot(time_axis, room_temp_trace, 'g', 'LineWidth',2);
ylabel('Room Temperature (°C)');

yline(desired_temp,'--g','Desired Temp','LineWidth',1.5);

xlabel('Time (hours)');
legend('HVAC Power','Room Temp','Desired Temp');
title('HVAC Power and Room Temperature');
grid on;

% ----- 4. Energy Usage Bar Chart -----
subplot(4,1,4)
bar([lighting_energy_kwh, hvac_energy_kwh, total_energy_kwh]);
set(gca,'xticklabel',{'Lighting','HVAC','Total'});
ylabel('Energy (kWh)');
title('Daily Energy Consumption');
grid on;

%% ----- PRINT ENERGY REPORT -----
fprintf("\n================ DAILY ENERGY REPORT ================\n");
fprintf("Lighting Energy Consumption      : %.2f kWh\n", lighting_energy_kwh);
fprintf("HVAC Energy Consumption          : %.2f kWh\n", hvac_energy_kwh);
fprintf("------------------------------------------------------\n");
fprintf("Total Daily Energy Consumption   : %.2f kWh\n", total_energy_kwh);
fprintf("Total Cost (@ ₹8 per kWh)        : ₹ %.2f\n", total_cost);
fprintf("======================================================\n");
