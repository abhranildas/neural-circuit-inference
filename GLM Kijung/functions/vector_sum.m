function [lambda_sum theta_sum] = vector_sum(param)

lambda1 = param(1);
lambda2 = param(2);
theta1 = param(3);
theta2 = param(4);

dx = lambda1*cos(theta1) + lambda2*cos(theta2);
dy = lambda2*sin(theta2) + lambda1*sin(theta1);

lambda_sum = sqrt(dx^2+dy^2);
theta_sum = atan(dy/dx);