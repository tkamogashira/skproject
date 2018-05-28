function H = dplot(dx, Y, varargin)
% dplot - plot data using regular spaced X-axis
%   dplot(dx, Y, ...) for arrays Y is equivalent to plot(dx*(0:length(y)-1), ...),
%   i.e., Y is plotted using a regularly spaced X-vector with offset 0
%   and increment dx. xplot also brings the current plot to the foreground.
%
%   For a matrix Y, dplot(dx, Y, ...) plots the columns of Y using a common
%   X-axis as described above.
%   
%   dplot([dx X0], Y) uses offset X0 instead of 0.
%
%   dplot(dt,Y, 'noshow', ...) suppresses bring the figure to the fore upon
%   plotting.
%
%   See also xdplot, xplot, timeaxis.


if nargin>2 && isequal('noshow', varargin{1}),
    doShow = 0;
    varargin = varargin(2:end);
else,
    doShow = 1;
end

x0=0;
if length(dx)>1, % 2nd element is offset (see help text)
    x0 = dx(2);
    dx = dx(1);
end
if size(Y,1)==1, % turn into column vector
    Y = Y(:); 
end
N = size(Y,1);
X = (x0+dx*(0:N-1)).'; % column vector
h = plot(X,Y, varargin{:});

if doShow, figure(gcf); end

% only return outarg if explicitly requested (suppress unwanted echoing)
if nargout>0,
    H  = h;
end
