clc
clear all
close all
warning off
syms x1 x2

% Get the deravative
% fg_equation = (10*x1^2+x2^2)/2 
% diff(fg,x1) diff(fg,x2)

fg= @(x1,x2) (10*x1^2+x2^2)/2 ;

gradient_x1 = @(x1,x2) (10*x1);
gradient_x2 = @(x1,x2) (x2);


fsurf(fg,[-20 20 -20 20]);
fontSize = 12;
xlabel('X1', 'FontSize', fontSize);
ylabel('X2', 'FontSize', fontSize);
zlabel('error', 'FontSize', fontSize);

pause(1);
hold on;

%Initial Value
x1_newton= 20;
x2_newton= 20;
x1_descent = 20;
x2_descent = 20;
t = 1;

iter = 100;
Newton_value = zeros(1,iter);
Descent_value = zeros(1,iter);


for i=1:iter 

    %     Finish your code here
    
    
    %     -------Newton's method + backtracking line search--------
    
    %     gradient1 = gradient_x1(x1,x2);
    %     gradient2 = gradient_x2(x1,x2);
    %     
    %     t = BLS(x1,x2,t,gradient1,gradient2,fg);
    %     x1_newton= 
    %     x2_newton= 
    %     
    %     ----------------Descent method---------------
    %     descent_step = 
    %     x1_descent= 
    %     x2_descent= 
        
    % store value in array
    Newton_value(1,i) = fg(x1_newton,x2_newton);
    Descent_value(1,i) = fg(x1_descent,x2_descent);

    % draw animation
    p1 = plot3(x1_newton, x2_newton, Newton_value(1,i),'*','linewidth',1.5,'Color','r');
    p2 = plot3(x1_descent, x2_descent, Descent_value(1,i),'*','linewidth',1.5,'Color','g');
    pause(0.03);

end

time_step = 1:1:iter;

figure(2);

% Plot position tracking error
plot(time_step,Newton_value,'r',time_step,Descent_value,'g',LineWidth=2.0);
title("Convex Optimization",'FontSize', 20);
legend("Newton's method with BLS",'Descent method','FontSize', 15)