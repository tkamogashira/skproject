function [outliers, h] = xbarplot(data,conf,specs)
%XBARPLOT X-bar chart for monitoring the mean.
%   XBARPLOT(DATA,CONF,SPECS) produces an xbar chart of
%   the grouped responses in DATA. The rows of DATA contain
%   replicate observations taken a a given time. The rows
%   should be in time order.
%
%   CONF (optional) is the confidence level of the upper and 
%   lower plotted confidence limits. CONF is 0.99 by default.
%   This means that 99% of the plotted points should fall 
%   between the control limits.
%
%   SPECS (optional) is a two element vector for the lower and
%   upper specification limits of the response.
%
%   OUTLIERS = XBARPLOT(DATA,CONF,SPECS) returns  a vector of 
%   indices to the rows where the mean of DATA is out of control.
%
%   [OUTLIERS, H] = XBARPLOT(DATA,CONF,SPECS) also returns a vector
%   of handles, H, to the plotted lines.

%   B.A. Jones 9/30/94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:47:10 $
 

if nargin < 2
   conf = 0.95;
end

if isempty(conf)
  conf = 0.95;
end

[m,n] = size(data);
xbar  = mean(data')';
avg   = mean(xbar);
s     = sqrt(sum(sum(((data - xbar(:,ones(n,1))).^2)))./(m*(n-1)));

tinverse = tinv(conf,m*(n-1));

UCL = avg + tinverse*s./sqrt(n-1);
LCL = avg - tinverse*s./sqrt(n-1);

tmp = NaN;
incontrol = tmp(1,ones(1,m));
outcontrol = incontrol;

greenpts = find(xbar > LCL & xbar < UCL);
redpts = find(xbar <= LCL | xbar >= UCL);

incontrol(greenpts) = xbar(greenpts);
outcontrol(redpts) = xbar(redpts);

samples = (1:m);

hh  = plot(samples,xbar,samples,UCL(ones(m,1),:),'r-',samples,avg(ones(m,1),:),'g-',...
           samples,LCL(ones(m,1),:),'r-',samples,incontrol,'y+',...
         samples,outcontrol,'r+');

if any(redpts)
  for k = 1:length(redpts)
     text(redpts(k) + 0.5,outcontrol(redpts(k)),num2str(redpts(k)));
  end
end

whitebg(gcf,[0 0 0]);

t1 = text(0.5,UCL,'UCL','Color','w');
t2 = text(0.5,LCL,'LCL','Color','w');
title('Xbar Chart','Color','w');
         
if nargin == 3
   set(gca,'NextPlot','add');
   LSL = specs(1);
   USL = specs(2);
   t3 = text(m + 0.5,USL,'USL','Color','w');
   t4 = text(m + 0.5,LSL,'LSL','Color','w');
   hh1 = plot(samples,LSL(ones(m,1),:),'g-',samples,USL(ones(m,1),:),'g-');
   set(gca,'NextPlot','replace');
   hh = [hh; hh1];
end

if nargout > 0
  outliers = redpts;
end

if nargout == 2
 h = hh;
end         

set(hh([3 5 6]),'LineWidth',2);
xlabel('Samples');
ylabel('Measurements');
