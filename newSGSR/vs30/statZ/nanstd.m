function y = nanstd(x)
%NANSTD Standard deviation ignoring NaNs.
%   NANSTD(X) returns the same standard deviation treating NaNs 
%   as missing values.
%
%   For vectors, NANSTD(X) is the standard deviation of the
%   non-NaN elements in X.  For matrices, NANSTD(X) is a row
%   vector containing the standard deviation of each column,
%   ignoring NaNs.
%
%   See also NANMEAN, NANMEDIAN, NANMIN, NANMAX, NANSUM.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:45:55 $

nans = isnan(x);
i = find(nans);

% Find mean
avg = nanmean(x);

if min(size(x))==1,
   count = length(x)-sum(nans);
   x = x - avg;
else
   count = size(x,1)-sum(nans);
   x = x - avg(ones(size(x,1),1),:);
end

% Replace NaNs with zeros.
x(i) = zeros(size(i));

% Protect against a column of all NaNs
i = find(count==0);
count(i) = ones(size(i));
y = sqrt(sum(x.*x)./max(count-1,1));
y(i) = i + NaN;
