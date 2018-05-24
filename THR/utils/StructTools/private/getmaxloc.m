function [XLoc, MaxY] = getmaxloc(X, Y, RunAvN, Range)
%GETMAXLOC get X-value corresponding to maximum Y-value.
%   XLoc = GETMAXLOC(X, Y) gives the X-value that corresponds to the maximum Y-value.
%
%   [XLoc, MaxY] = GETMAXLOC(X, Y, RunAvN) does the same but the maximum is calculated after a running 
%   average of RunAvN number of elements has been done on the curve. The maximum Y-value is also returned.
%
%   XLoc = GETMAXLOC(X, Y, RunAvN, Range) gives the maximum in the range given by the two element vector Range.
%   Range should be given in the same units as the X-vector.

% B. Van de Sande 14-08-2005
% Adjusted by Kevin Spiritus 2007-03-12

if nargin < 2
    error('Wrong number of input parameters.'); 
end
if ~isa(X, 'double') | ~isa(Y, 'double')
    error('First two arguments should be vectors.'); 
end

if nargin == 2
    RunAvN = 0;
    Range  = [-Inf +Inf];
elseif nargin == 3
    Range  = [-Inf +Inf]; 
end
    
%iMin = max(find(X <= Range(1))); if isempty(iMin), iMin = 1; end
%iMax = min(find(X >= Range(2))); if isempty(iMax), iMax = length(X); end
iMin = max(find(X < Range(1)))+1; 
iMax = min(find(X > Range(2)))-1; 
if isempty(iMin)
    iMin = 1; 
end
if isempty(iMax)
    iMax = length(X); 
end

[MaxY, idx] = max(runav(Y(iMin:iMax), RunAvN));
XLoc = X(idx+iMin-1);
if isempty(MaxY)
    MaxY = NaN; 
end
if isempty(XLoc)
    XLoc = NaN; 
end