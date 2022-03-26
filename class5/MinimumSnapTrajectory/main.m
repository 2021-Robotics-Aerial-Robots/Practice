% Edit form https://github.com/Mesywang/Motion-Planning-Algorithms
clc;clear;close all;
n = 10;
path = [];

for i=1:n
    [x, y] = ginput(1);
    path(i,:) = [x, y];
    plot(path(:,1), path(:,2), 'r*');
    xlim([0 1])
    ylim([0 1])
    X = [num2str(i),'  point'];
    disp(X)
end
hold off
path = path*100;

          
n_order       = 7;% order of poly
n_seg         = size(path,1)-1;% segment number
n_poly_perseg = (n_order+1); % coef number of perseg

ts = zeros(n_seg, 1);% time of perseg

% calculate time distribution in proportion to distance between 2 points
dist     = zeros(n_seg, 1);
dist_sum = 0;
T        = 10;% total time
t_sum    = 0;

for i = 1:n_seg
    dist(i) = sqrt((path(i+1, 1)-path(i, 1))^2 + (path(i+1, 2) - path(i, 2))^2);% distance between waypoints
    dist_sum = dist_sum + dist(i);% total distance
end
for i = 1:n_seg-1
    ts(i) = dist(i)/dist_sum*T;% ts(i):time of each trajectory
    t_sum = t_sum+ts(i);
end
ts(n_seg) = T - t_sum;


% Enter the point, time , segment, and order to fit
poly_coef_x = MinimumSnapQPSolver(path(:, 1), ts, n_seg, n_order);
poly_coef_y = MinimumSnapQPSolver(path(:, 2), ts, n_seg, n_order);

% display the trajectory
X_n = [];
Y_n = [];
Vx_n = [];
Vy_n = [];
k = 1;
tstep = 0.01;
for i=0:n_seg-1
    %#####################################################
    % STEP 3: get the coefficients of i-th segment of both x-axis and y-axis
    Pxi = poly_coef_x(1+8*i:1+8*i+7);
    Pyi = poly_coef_y(1+8*i:1+8*i+7);
    Vxi = derivative_s(Pxi,7);
    Vyi = derivative_s(Pyi,7);
    Axi = derivative_s(Vxi,6);
    Ayi = derivative_s(Vyi,6);
    Jxi = derivative_s(Axi,5);
    Jyi = derivative_s(Ayi,5);

    
    for t = 0:tstep:ts(i+1)
        X_n(k)  = polyval(Pxi, t);
        Y_n(k)  = polyval(Pyi, t);
        Vx_n(k) = polyval(Vxi, t);
        Vy_n(k) = polyval(Vyi,t);
        Ax_n(k) = polyval(Axi, t);
        Ay_n(k) = polyval(Ayi,t);
        Jx_n(k) = polyval(Jxi, t);
        Jy_n(k) = polyval(Jyi,t);
        k = k + 1;
    end
end

figure(1);

title("Path of Minimum snap trajectory");
plot(X_n, Y_n , 'Color', [0 1.0 0], 'LineWidth', 2);
xlim([0 100])
ylim([0 100])
hold on
scatter(path(1:size(path, 1), 1), path(1:size(path, 1), 2) ,'r*');

t = 0:1:length(X_n)-1;
t = t*tstep;

figure(2);
xlim([0 length(t)])
subplot(3,2,1);
plot(t,Vx_n);
title('Velocity of x');
grid
subplot(3,2,2);
plot(t,Vy_n);
title('Velocity of y');
grid
subplot(3,2,3);
plot(t,Ax_n);
title('Accrleration of x');
grid
subplot(3,2,4);
plot(t,Ay_n);
title('Accrleration of y');
grid

subplot(3,2,5);
plot(t,Jx_n);
title('Jerk of x');
xlabel('Time(s)')
grid

subplot(3,2,6);
plot(t,Jy_n);
title('Jerk of y');
xlabel('Time(s)')
grid

function poly_coef = MinimumSnapQPSolver(waypoints, ts, n_seg, n_order)
    start_cond = [waypoints(1), 0, 0, 0];% p,v,a,j
    end_cond   = [waypoints(end), 0, 0, 0];% p,v,a,j
    %#####################################################
    % STEP 1: compute Q of p'Qp
    Q = getQ(n_seg, n_order, ts);
    %#####################################################
    % STEP 2: compute Aeq and beq 
    [Aeq, beq] = getAbeq(n_seg, n_order, waypoints, ts, start_cond, end_cond);
    f = zeros(size(Q,1),1);
    poly_coef = quadprog(Q,f,[],[],Aeq, beq);% X = QUADPROG(H,f,A,b,Aeq,beq)
end