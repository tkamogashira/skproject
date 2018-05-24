function t= timeaxis(y, dt, t0);
% timeaxis - evenly spaced array for time axis
%    timeaxis(y, dt, t0) returns an array having the same size as y ,
%    starting at value t0 and having a constant increment dt.
%    Defaults: dt=1; t0=0.
%
%    For a matrix y, the first dimension is taken as the "time", and a
%    column array is returned of length size(y,1);
%
%    See also, dplot, xdplot, logispace.

if nargin<2, dt=1; end
if nargin<3, t0=0; end

isRow = isvector(y) && size(y,2)>1;
if isRow,
    y = y(:);
end

N = size(y,1);

t = t0 + dt*(0:N-1).';

if isRow, t = t.'; end



