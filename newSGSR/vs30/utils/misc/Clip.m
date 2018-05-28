function x = Clip(x, imin, imax);
% CLIP - clip array between a min and a max value
if nargin<3, imax=inf; end;
low = find(x<imin);
high = find(x>imax);
if ~isempty(low), x(low) = imin; end;
if ~isempty(high), x(high) = imax; end;
