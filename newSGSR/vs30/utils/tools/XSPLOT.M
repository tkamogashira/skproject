function hh=xSplot(x,y,varargin);
% xSplot - add splinal plot to current axes
%  xSplot(X,Y,...)

fake = 0;
% remove nans
[dum ix] = denan(x); [dum iy] = denan(y);
iok = intersect(ix,iy);
if length(iok)<3, return; end
x = x(iok); y = y(iok);
X = linspace(min(x),max(x));
Y = spline(x,y,X);
if nargin>2,
   fake = isequal('n', varargin{end});
end

if fake, hh=plot(X,Y,varargin{1:(end-1)});
else 
   hold on;
   hh=plot(X,Y,varargin{:});
   hold off;
end
figure(gcf);
   