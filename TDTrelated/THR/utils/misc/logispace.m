function y=logispace(x1,x2,N);
% logispace - Truly logarithmically spaced vector.
%   logispace(X1,X2,N) returns a row vector of N logarithmically equally
%   spaced point between X1 and X2. N defaults to 100.
%
%   See also LINSPACE.

if nargin<3, N=100; end
y = exp(linspace(log(x1), log(x2), N));
% force exact bounds
y(1) = x1;
y(end) = x2;





