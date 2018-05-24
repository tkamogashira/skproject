function dashplot(X, Y, DX, varargin);
%  dashplot - plot horizontal lines at specified positions
%      dashplot(X, Y, DX) plots horizontal lines centered at X(k), Y(k)
%      having length DX.
%      Optional plot arguments may be passed as in dashplot(X,Y, DX, 'r:')
%
%      See also fenceplot.

X = X(:).'; 
X = [X-0.5*DX; X+0.5*DX];
Y = Y(:).';
Y = [Y;Y];
xplot(X,Y,varargin{:});




