function boxplot(x,notch,sym,vert,whis)
%BOXPLOT Display boxplots of a data sample.
%   BOXPLOT(X,NOTCH,SYM,VERT,WHIS) produces a box and whisker plot for
%   each column of X. The box has lines at the lower quartile, median, 
%   and upper quartile values. The whiskers are lines extending from 
%   each end of the box to show the extent of the rest of the data. 
%   Outliers are data with values beyond the ends of the whiskers.
% 
%   NOTCH = 1 produces a notched-box plot. Notches represent a robust 
%   estimate of the uncertainty about the means for box to box comparison.
%   NOTCH = 0 (default) produces a rectangular box plot. 
%   SYM sets the symbol for the outlier values if any (default='+'). 
%   VERT = 0 makes the boxes horizontal (default: VERT = 1, for vertical).
%   WHIS defines the length of the whiskers as a function of the IQR
%   (default = 1.5). If WHIS = 0 then BOXPLOT displays all data  
%   values outside the box using the plotting symbol, SYM.   
%
%   If there are no data outside the whisker, then, there is a dot at the 
%   bottom whisker, the dot color is the same as the whisker color. If
%   a whisker falls inside the box, we choose not to draw it. To force
%   it to be drawn at the right place, set whissw = 1.
%
%   BOXPLOT calls BOXUTIL to do the actual plotting.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1998/03/13 22:19:39 $

[xrow,xcol] = size(x);

whissw = 0; % don't plot whisker inside the box.

if min(xrow,xcol) > 1 
    [m n] = size(x);
    xx = x(:,1);
    yy = xx;
else
    n = 1;
    xx = x;
    yy = x;
end

lb = 1:n;

if nargin < 2, 
    notch = 0;                      
end

if nargin < 3, 
    sym = 'r+';
end

if nargin < 4, 
    vert = 1;                        
end

if nargin < 5, 
    whis = 1.5;                      
end

xlims = [0.5 n + 0.5];

k = find(~isnan(x));
ymin = min(min(x(k)));
ymax = max(max(x(k)));
dy = (ymax-ymin)/20;
ylims = [(ymin-dy) (ymax+dy)];

lf = n*min(0.15,0.5/n);

% Scale axis for vertical or horizontal boxes.
cla
set(gca,'NextPlot','add','Box','on');
if vert
    axis([xlims ylims]);
    set(gca,'XTick',lb);
    set(gca,'YLabel',text(0,0,'Values'));
    set(gca,'XLabel',text(0,0,'Column Number'));
else
    axis([ylims xlims]);
    set(gca,'YTick',lb);
    set(gca,'XLabel',text(0,0,'Values'));
    set(gca,'YLabel',text(0,0,'Column Number'));
end

if n==1
   vec = find(~isnan(yy));
   if ~isempty(vec)
      boxutil(yy(vec),notch,lb,lf,sym,vert,whis,whissw);
   end
else
   for i=1:n
      z = x(:,i);
      vec = find(~isnan(z));
      if ~isempty(vec)
         boxutil(z(vec),notch,lb(i),lf,sym,vert,whis,whissw);
      end
   end
end
set(gca,'NextPlot','replace');
