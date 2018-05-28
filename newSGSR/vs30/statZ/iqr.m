function y = iqr(x)
%IQR    Interquartile Range. 
%   Y = IQR(X) calculates the interquarile range (IQR) of the input.
%   Given a vector input, the IQR is formed by subtracting the 25th 
%   percentile of the data from the 75th percentile of the data.
%   (See PRCTILE)
%
%   The IQR is a robust estimate of the spread of the data since changes
%   in the upper and lower 25% of the data do not affect it.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:42 $

zlo = prctile(x,25);
zhi = prctile(x,75);
y = zhi - zlo;
