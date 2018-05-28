function dplot(DX,Y, varargin);
% dplot - plot with scaled x values
%    syntax: dplot(DX,Y, varargin);
%    See also xdplot

if length(DX)==1,
   X0 = 0;
else,
   X0 = DX(2);
   DX = DX(1);
end
[N, dimlen] = max(size(Y));
X(1:N)=X0+(0:N-1)*DX;
if dimlen==1,
    X = X.';
end
%dsiz(X,Y);
figure(gcf);
plot(X,Y,varargin{:});