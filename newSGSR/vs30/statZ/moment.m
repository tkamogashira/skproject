function sigma = moment(data,order)
% MOMENT Central moments of all orders.
%   MOMENT(DATA,ORDER) returns the central moment of DATA 
%   specified by the positive integer, ORDER.
%   For matrix, DATA, MOMENT returns central moments of the  
%   specified order for each column in DATA.
%   Note: the central first moment is zero. Also the 
%   central second moment is the variance using a divisor
%   of N instead of N-1 where N is the sample size.
%
%   See also MEAN, STD, VAR, SKEWNESS, KURTOSIS.

%   B.A. Jones 1/20/95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 1.5 $  $Date: 1997/11/29 01:45:51 $

[rows, cols] = size(data);

if rows == 1,
  data = data(:);
  rows = cols;
  cols = 1;
end

[m,n] = size(order);
if max(m,n) ~= 1
    error('Requires a scalar second argument.');
end
if  (order - floor(order)) > 0 | order < 1
    error('Requires a positive integer second argument.');
end

if order == 1
   sigma = zeros(1,cols);
else
   mu = mean(data);
   mu = mu(ones(rows,1),:);
   sigma = mean((data - mu).^order);
end  
