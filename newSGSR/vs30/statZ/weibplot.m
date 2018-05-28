function h = weibplot(x)
%WEIBPLOT Weibull probability plot.
%   H = WEIBPLOT(X) displays a Weibull probability plot of the  
%   data in X. For matrix, X, WEIBPLOT displays a plot for each column.
%   H is a handle to the plotted lines.
%   
%   The purpose of a Weibull probability plot is to graphically assess
%   whether the data in X could come from a Weibull distribution. If the
%   data are Weibull the plot will be linear. Other distribution types 
%   will introduce curvature in the plot.  

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/08/14 22:20:12 $


[n, m] = size(x);
if n == 1
   x = x';
   n = m;
   m = 1;
end

[sx i]= sort(x);
minx  = min(sx(1,:));
maxx  = max(sx(n,:));
range = maxx-minx;

if range > 0
  minxaxis  = 0;
  maxxaxis  = maxx+0.025*range;
else
  minxaxis  = minx - 1;
  maxxaxis  = maxx + 1;
end

eprob = [0.5./n:1./n:(n - 0.5)./n]';
y  = log(log(1./(1-eprob)));
y  = y(:,ones(1,m));

minyaxis  = log(log(1./(1 - 0.25 ./n)));
maxyaxis  = log(log(1./(0.25 ./n)));


p     = [0.001 0.003 0.01 0.02 0.05 0.10 0.25 0.5...
         0.75 0.90 0.96 0.99 0.999];

label1= str2mat('0.001','0.003', '0.01','0.02','0.05','0.10','0.25','0.50');
label2= str2mat('0.75','0.90','0.96','0.99', '0.999');
label = [label1;label2];

tick  = log(log(1./(1-p)));

q1x = prctile(x,25);
q3x = prctile(x,75);
q1y = prctile(y,25);
q3y = prctile(y,75);

qx = [q1x; q3x];
qy = [q1y; q3y];

b = zeros(m,2);
mx = [minx maxx];
mx = mx(ones(m,1),:);
my = zeros(m,2);

for k = 1:m
   b(k,:) = polyfit(log(qx(:,k)),qy(:,k),1);
   my(k,:) = polyval(b(k,:),log(mx(k,:)));
end
mx = mx';
my = my';

if nargout == 1
   h = plot(sx,y,'+',qx,qy,'-',mx,my,'-.');
else 
   g = plot(sx,y,'+',qx,qy,'-',mx,my,'-.');
end

whitebg(gcf,[0 0 0]);

set(gca,'YTick',tick,'YTickLabel',label,'XScale','log');
set(gca,'YLim',[minyaxis maxyaxis],'XLim',[minxaxis maxxaxis]);
xlabel('Data');
ylabel('Probability');
title('Weibull Probability Plot','Color','w');

grid on;
