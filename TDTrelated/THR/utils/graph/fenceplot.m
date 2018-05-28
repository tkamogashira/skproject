function fenceplot(X,Ylim, varargin);
%  fenceplot - plot vertical lines at specified horizontal positions
%      fenceplot(X,[Y1 Y2]) plots vertical lines at horizontal positions X(1),
%      X(2),... . Y1 and Y2 indicate the vertical range of the lines.
%      Optional plot arguments may be passed as in fenceplot(X,[Y1 Y2], 'r:')
%
%      See also dashplot.

X = X(:).'; % col vector
X3 = [X; X; nan+X];
X3 = X3(:);

Y = zeros(size(X));
Y = [Y+Ylim(1); Y+Ylim(2); Y];
Y = Y(:);
xplot(X3,Y,varargin{:});




