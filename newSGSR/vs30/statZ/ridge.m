function b = ridge(y,X,k)
%RIDGE Ridge regression.
%   B = RIDGE(Y,X,K) returns the vector of regression coefficients, B.
%   Given the linear model: y = Xb, 
%   X is an n by p matrix, y is the n by 1 vector of observations and k
%   is a scalar constant.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:39 $

if  nargin < 3,              
    error('Requires at least three input arguments.');      
end 

% Make sure k is a scalar.
if prod(size(k)) ~= 1
   error('K must be a scalar.');
end

% Check that matrix (X) and left hand side (y) have compatible dimensions
[n,p] = size(X);

[n1,collhs] = size(y);
if n~=n1, 
    error('The number of rows in Y must equal the number of rows in X.'); 
end 

if collhs ~= 1, 
    error('Y must be a column vector.'); 
end

% Normalize the columns of X to mean, zero, and standard deviation, one.
mx = mean(X);
stdx = std(X);
idx = find(abs(stdx) < sqrt(eps)); 
if any(idx)
  stdx(idx) = 1;
end

MX = mx(ones(n,1),:);
STDX = stdx(ones(n,1),:);
Z = (X - MX) ./ STDX;
if any(idx)
  Z(:,idx) = ones(n,length(idx));
end

% Create matrix of pseudo-observations and add to the Z and y data.
pseudo = sqrt(k) * eye(p);
Zplus  = [Z;pseudo];
yplus  = [y;zeros(p,1)];

% Solve the linear system for regression coefficients.
b = Zplus\yplus;
