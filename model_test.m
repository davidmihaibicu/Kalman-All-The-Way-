% 1. System Configuration
dt = 1.0; 

% F Matrix (State Transition)
F = [1 0 dt 0;
     0 1 0 dt;
     0 0 1 0;
     0 0 0 1];

% --- NEW: B Matrix (Control Input Model) ---
% Maps acceleration to position/velocity
B = [(0.5 * dt^2) 0;
     0            (0.5 * dt^2);
     dt           0;
     0            dt];

% --- NEW: Control Vector u ---
% Let's apply a constant acceleration:
% 0.1 m/s^2 in X, 0.05 m/s^2 in Y
u = [0.1; -0.05];

% H Matrix (Measurement)
H = [1 0 0 0;
     0 1 0 0];

% 2. Simulation Settings
num_steps = 50;
true_initial_state = [0; 0; 1; 1]; 
measurement_noise_std = 1.5;       
process_noise_std = 0.1;           

% Create Ground Truth Data (Now with Acceleration!)
ground_truth = zeros(4, num_steps);
current_state = true_initial_state;

for i = 1:num_steps
    ground_truth(:, i) = current_state;
    
    % --- NEW: Evolve state using F AND B ---
    % The object moves due to velocity (F) AND acceleration (B)
    current_state = F * current_state + B * u;
end

% Create Noisy Measurements
measurements = zeros(2, num_steps);
for i = 1:num_steps
    mx = ground_truth(1, i) + measurement_noise_std * randn();
    my = ground_truth(2, i) + measurement_noise_std * randn();
    measurements(:, i) = [mx; my];
end

% 3. Kalman Filter Initialization
x_est = [0; 0; 0; 0]; 
P = eye(4) * 1000;
R = eye(2) * measurement_noise_std^2;
Q = eye(4) * process_noise_std^2;

estimated_path = zeros(4, num_steps);

% 4. The Kalman Loop
for i = 1:num_steps
    z = measurements(:, i);
    
    % --- PREDICT ---
    % Predict next state based on physics (F) AND Input (B)
    % We tell the filter: "I know I am pushing the gas pedal (u)"
    x_pred = F * x_est + B * u;
    
    % Predict next uncertainty (B and u do not typically increase uncertainty)
    P_pred = F * P * F' + Q;
    
    % --- UPDATE (Standard) ---
    y_res = z - H * x_pred;
    S = H * P_pred * H' + R;
    K = P_pred * H' / S; % "/" is more stable than inv()
    x_est = x_pred + K * y_res;
    P = (eye(4) - K * H) * P_pred;
    
    estimated_path(:, i) = x_est;
end

% 5. Visualization
figure;
hold on; grid on;

% Ground truth will now look like a CURVE (parabola)
plot(ground_truth(1, :), ground_truth(2, :), 'g-', 'LineWidth', 2, 'DisplayName', 'Ground Truth (Accelerating)');
scatter(measurements(1, :), measurements(2, :), 'r', 'x', 'DisplayName', 'Noisy Measurements');
plot(estimated_path(1, :), estimated_path(2, :), 'b--', 'LineWidth', 2, 'DisplayName', 'Kalman Estimate');

title('Kalman Filter with Control Input (Acceleration)');
xlabel('X Position');
ylabel('Y Position');
legend('show', 'Location', 'best');
hold off;