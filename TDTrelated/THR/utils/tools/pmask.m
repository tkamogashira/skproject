function ma = pmask(x);
% PMASK - plot mask for selective plotting 
%   M = PMASK(V), where V is a logical vector, returns a vector the
%   same size as V with zeros where V is true and NaNs where ~V.
%   When added to a plot argument, data points k for which V(k)==0 are 
%   not plotted.

ma = 0*x;
inx = find(~x);
if ~isempty(inx), ma(inx) = nan; end;


