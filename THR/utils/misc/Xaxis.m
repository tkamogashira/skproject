function x = Xaxis(y, dx, x0);
% Xaxis - evenly spaced array for X axis
%    Xaxis(y, dx, x0) returns an array having the same size as y ,
%    starting at value x0 and having a constant increment dx.
%    Defaults: xt=1; x0=0.
%
%    For a matrix y, the first dimension is taken as the X, and a
%    column array is returned of length size(y,1);
%
%    See also, timeaxis, dplot, xdplot, logispace.

if nargin<2, dx=1; end
if nargin<3, x0=0; end

isRow = isvector(y) && size(y,2)>1;
if isRow,
    y = y(:);
end

N = size(y,1);

x = x0 + dx*(0:N-1).';

if isRow, x = x.'; end



