function [means, sem, counts] = grpstats(x,group,alpha)
%GRPSTATS Summary statistics by group.
%   GRPSTATS(X,GROUP) Returns the MEANS of each column of X by GROUP
%   X is a matrix of observations. GROUP is a vector of  positive integers that
%   indicates the group membership of each row in X. 
%
%   [MEANS,SEM, COUNTS] = GRPSTATS(X,GROUP) supplies the standard error of the 
%   mean in SEM. COUNTS is the same size as the other outputs. The ith row of 
%   COUNTS contains the number of elements in the ith GROUP. 
%
%   GRPSTATS(X,GROUP,ALPHA) displays a plot of the means versus index with
%   100(1 - ALPHA)%  confidence intervals around each mean.

%   B.A. Jones 3-5-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1997/11/29 01:45:35 $

[row,cols] = size(x);
n      = max(group(~isnan(group)));
means  = zeros(n,cols);
sem    = means;
counts = means;

for idx1 = 1:cols
   k = find(~isnan(x(:,idx1)) & ~isnan(group));
   y = x(k,idx1);
   idx = group(k);
   if any(any(group)) < 0 | any(any(group)) ~= floor(group)
     error('Requires a vector second input argument with only positive integers.');
   end

   for idx2 = 1:n
     k = find(idx == idx2);
     means(idx2,idx1)   = mean(y(k));
     sem(idx2,idx1)    = std(y(k));
     sem(idx2,idx1)    = sem(idx2,idx1) ./ sqrt(length(k));
     counts(idx2,idx1) = length(k);
   end
end

if nargin == 3
   p = 1 - alpha/2;
   xd = (1:n)';
   xd = xd(:,ones(cols,1));
   h = errorbar(xd,means,tinv(p,counts) .* sem);
   set(h(2),'LineStyle','none','Marker','o','MarkerSize',2);
   set(gca,'Xlim',[0.5 n+0.5],'Xtick',(1:n));
   xlabel('Group Number');
   ylabel('Mean');
   title('Means and Confidence Intervals for Each Group');
   grid on
end
