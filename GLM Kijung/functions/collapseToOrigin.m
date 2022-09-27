function [X] = collapseToOrigin(X)

X(X(:,1)>=0.5,1) = X(X(:,1)>=0.5,1) - 1;
X(X(:,2)>=0.5,2) = X(X(:,2)>=0.5,2) - 1;