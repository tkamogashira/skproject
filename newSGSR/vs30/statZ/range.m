function y = range(x)
%RANGE  The range is the difference between the maximum and minimum values. 
%   Y = RANGE(X) calculates the range of the input.
%   For matrices RANGE(X) is a vector containing the range for each column.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:31 $

y = max(x) - min(x);
