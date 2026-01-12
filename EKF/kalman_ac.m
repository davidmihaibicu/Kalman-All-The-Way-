%% MATLAB Pre-Calculation for FPGA (Corrected with B Matrix)
clear
close all
clc

FixedPointPrecision = fixdt(1, 32, 20);

% 1. Define Model (From your code)
dt = 0.02;
StopTime = 10;

ampli = 0.1;

F = single([1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1]); % Constanta (trebuie sa fac jacobian)
B = single([0.5*dt^2 0; 0 0.5*dt^2; dt 0; 0 dt]); % 4x2 Matrix
H = single(diag([1,1,1,1]));
Q = single(0.1 * eye(4));
R = single(diag([1, 1, ampli, ampli]));

time = single(0:dt:StopTime);

x = [0;0;0;0];
u = single(ones(2, size(time, 2))');
u = single([1;1]*cos(time))';

for i = 1:size(time, 2)
    x = [x, F*x(:,i) + B*u(i, :)'];
end
x = x(:, 2:end);
z = x + ampli * randn(4, size(time,2));
z = H*z;
z=z';

% Precompute constant matrices for Taylor-based inverse approximation

m = size(H,1);
n = size(H,2);

% Taylor expansion center X = I

% Constant inverse
C = eye(4)/(H*H' + R);

% Precompute CHE_{u,l}H^TC tensors

k = 0;
for ui = 1:n
    for li = 1:n
        k = k + 1;

        E = zeros(n,n);
        E(ui,li) = 1;

        Ti = C * H * E * H' * C;

        % Create variables T1, T2, ..., T16 in the workspace
        assignin('base', sprintf('T%d', k), Ti);
    end
end

