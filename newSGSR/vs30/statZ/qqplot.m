function h = qqplot(x,y,pvec)
%QQPLOT Displays an empirical quantile-quantile plot.
%   QQPLOT(X,Y) makes an empirical QQ-plot of the quantiles of
%   the data set X versus the quantiles of the data set Y.
%   H = QQPLOT(X,Y,PVEC) allows you to specify the plotted quantiles in 
%   the vector PVEC. H is a handle to the plotted lines. 
%
%   The default quantiles are those of the smaller data set.
%
%   The purpose of the quantile-quantile plot is to determine whether 
%   the samples in X and Y come from the same distribution type (parameter
%   values may be different.) If the samples do come from the same
%   distribution, the plot will be linear.  

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/06/23 13:09:48 $

if nargin < 3
    n=min(length(x),length(y));
    pvec=100*((1:n) - 0.5) ./ n;
else 
    n = length(pvec);
end


if length(x) == n
    xx = sort(x);
else
    xx = prctile(x,pvec);
end
if length(y) == n
    yy = sort(y);
else
    yy=prctile(y,pvec);
end

q1x = prctile(x,25);
q3x = prctile(x,75);
q1y = prctile(y,25);
q3y = prctile(y,75);
qx = [q1x; q3x];
qy = [q1y; q3y];


dx = q3x - q1x;
dy = q3y - q1y;
slope = dy./dx;
centerx = (q1x + q3x)/2;
centery = (q1y + q3y)/2;
maxx = max(x);
minx = min(x);
maxy = centery + slope.*(maxx - centerx);
miny = centery - slope.*(centerx - minx);

mx = [minx; maxx];
my = [miny; maxy];


hh = plot(xx,yy,'+',qx,qy,'-',mx,my,'-.');
if nargout == 1
  h = hh;
end

xlabel('X Quantiles');
ylabel('Y Quantiles');
