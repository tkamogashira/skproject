function [xd, yd] = cdiff(x, y)
%CDIFF central difference approximation.
%   [xd, yd] = CDIFF(x, y) calculates the numerical derivative of the function given by the sampled
%   data x and y. A central difference approximation is used:
%                   dy(n)/dx = (y(n+1) - y(n-1)) / (x(n+1) - x(n-1))
%   
%   See also DIFF

%B. Van de Sande 25-04-2003

yd = (y(3:end) - y(1:end-2)) ./ (x(3:end) - x(1:end-2));
xd = x(2:end-1);