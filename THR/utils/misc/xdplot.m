function H = xdplot(dx, Y, varargin)
% dplot - plot data using regular spaced X-axis to existing plot
%   xdplot(dx, Y, ...) is a combination of dplot and xplot.
%   It uses a X-axis spacing of dx and and adds to an existing plot
%   rather than overwriting it.
%
%   See also dplot, xplot.

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
h = xplot(X,Y, varargin{:});

if doShow, figure(gcf); end


% only return outarg if explicitly requested (suppress unwanted echoing)
if nargout>0,
    H  = h;
end


