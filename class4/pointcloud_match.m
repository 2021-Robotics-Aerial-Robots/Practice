%% set up
% Start tidy
clc;
close all
clear;

% Make some points as a model
Nx = 100;
X = rand( 3, Nx ) * 10;

% Make a Rotation and translation
t = rand( 3, 1 ) * 10;

% Select random rotation angles
theta = rand() * 30;
phi = rand() * 30;
psi = rand() * 30;

R = eul2rotm( deg2rad( [ theta, phi, psi] ), 'ZYX' );

% Select a subset of the points
Np = 100;
noise = rand(3,Nx)*0.2;
X_noise = X + noise;

% P is X after rotation and translation
P = R' * (X_noise - repmat( t, 1, Np ));


%% ICP
tic
[Rr,tr, k] = icp( P, X, 0.001 );
time = toc;

fprintf("ICP time (s): %f \n",time);
np_ICP = Rr * P + repmat( tr, 1, Np );
ICP_norm = norm(X-np_ICP);
fprintf("ICP Error:　%f\n\n", ICP_norm );


%% Linear Optimization

% P_after is the point cloud after the rotation , but without the
% translation(Linear Optimization cannot handle the drift term)

P_linearoptim = P + R'*repmat(t,1,Np);

tic
R_d = LinearOptimization(P_linearoptim,Np, X);
time = toc;

fprintf("Linear Optimization time (s): %f \n",time)
% caculate the error
np_LSM = R_d * P + repmat( tr, 1, Np );
LSM_norm = norm(X-np_LSM);
fprintf("Linear Optimnization Error:　%f\n\n", LSM_norm );

%% Plot the originals and the recovered points
% Model
figure(1);
tiledlayout(1,2);
nexttile
scatter3( X(1,:), X(2,:) , X(3,:) , 'ro' );
axis vis3d
hold
xlim([-10 10])
ylim([-10 10])
zlim([-10 10])
% Original P
scatter3( P(1,:), P(2,:) , P(3,:) , 'MarkerEdgeColor',[0 0.7 0.7]);
title("Before",'FontSize', 20);


nexttile
%% Plot the point cloud after ICP and Linear Optimization
scatter3( X(1,:), X(2,:) , X(3,:) , 'ro' );
axis vis3d
hold
xlim([-10 10])
ylim([-10 10])
zlim([-10 10])

% P fitted to X
scatter3( np_LSM(1,:), np_LSM(2,:) , np_LSM(3,:) , 'MarkerEdgeColor',[0 0.7 0.7]);

% P fitted to XP
scatter3( np_ICP(1,:), np_ICP(2,:) , np_ICP(3,:) , 'b+');
title("After",'FontSize', 20);
legend('Groundtruth','Linear Optimization','ICP','FontSize', 15)


