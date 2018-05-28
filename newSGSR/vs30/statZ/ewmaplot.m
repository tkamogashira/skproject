function h = ewmaplot(data,lambda,alpha,specs)
%EWMAPLOT Exponentially weighted moving average chart.
%   H = EWMAPLOT(DATA,LAMBDA,ALPHA,SPECS) produces an EWMA chart 
%   of the grouped responses in DATA. The rows of DATA contain
%   replicate observations taken at a given time. The rows
%   should be in time order.
%
%   LAMBDA (optional) is the parameter that controls how much 
%   the current prediction is influenced by past observations. 
%   Higher values of LAMBDA give more weight to past observations. 
%   By default, LAMBDA = 0.4, and LAMBDA must be between 0 and 1. 
%
%   ALPHA (optional) is the significance level of the upper and 
%   lower plotted confidence limits. ALPHA is 0.01 by default.
%   This means that 99% of the plotted points should fall 
%   between the control limits.
%
%   SPECS (optional) is a two element vector for the lower and
%   upper specification limits of the response.
%
%   H is a vector of handles to the plotted lines.

%   Reference: Montgomery, Douglas, Introduction to Statistical
%   Quality Control, John Wiley & Sons 1991 p. 299.

%   B.A. Jones 2-13-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:15 $
 

if nargin < 3
   alpha = 0.01;
end

if nargin < 2
   lambda = 0.4;
end

if isempty(alpha)
  alpha = 0.01;
end

if isempty(lambda)
   lambda = 0.4;
end

if lambda < 0 | lambda > 1
   error('The second argument must be a scalar between 0 and 1.');
end
ciprob = 1-alpha/2;

[m,n] = size(data);
if n == 1
   xbar = data;
else
   xbar  = (mean(data'))';
end

avg   = mean(xbar);
z     = filter(lambda,[1 (lambda - 1)],xbar,(1-lambda)*avg);
sbar  = mean(std(data'));

if n == 1
   tinverse = norminv(ciprob);
else
   tinverse = tinv(ciprob,n-1);
end


lambdacoef = sqrt(lambda./((2-lambda).*n));
UCL = avg + tinverse*sbar*lambdacoef;
LCL = avg - tinverse*sbar*lambdacoef;

tmp = NaN;
incontrol = tmp(ones(1,m));
outcontrol = incontrol;

greenpts = find(z > LCL & z < UCL);
redpts = find(z <= LCL | z >= UCL);

incontrol(greenpts) = z(greenpts);
outcontrol(redpts) = z(redpts);

samples = (1:m);

hh  = plot(samples,z,samples,UCL(ones(m,1),:),'b-',samples,avg(ones(m,1),:),'r-',...
           samples,LCL(ones(m,1),:),'b-',samples,incontrol,'y+',...
         samples,outcontrol,'r+');

if any(redpts)
  for k = 1:length(redpts)
     text(redpts(k) + 0.5,outcontrol(redpts(k)),num2str(redpts(k)),'color','w');
  end
end

t1 = text(0.5,UCL,'UCL');
t2 = text(0.5,LCL,'LCL');
title('Exponentially Weighted Moving Average (EWMA) Chart');
         
if nargin == 4
   set(gca,'NextPlot','add');
   LSL = specs(1);
   USL = specs(2);
   t3 = text(m + 0.5,USL,'USL');
   t4 = text(m + 0.5,LSL,'LSL');
   hh1 = plot(samples,LSL(ones(m,1),:),'c-',samples,USL(ones(m,1),:),'c-');
   set(gca,'NextPlot','replace');
   hh = [hh; hh1];
end

if nargout == 1
   h = hh;
end         

set(hh(3),'LineWidth',2);
whitebg(gcf,[0 0 0]);

xlabel('Sample Number');
ylabel('EWMA');
