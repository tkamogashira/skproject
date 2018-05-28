function [MI, MA, IMI, IMA] = MinMax(varargin);
% MinMax - minimum and maximum in one call
%   [mi, ma] = MinMax(...) is the same as the
%   double call:
%     mi = min(...); ma = max(...)
%
%   [mi, ma, i, j] = MinMax(...) is the same as
%     [mi, i] = min(...); [ma, j] = max(...)
%
%   See MIN, MAX.
if nargout>2, 
   [MI, IMI] = min(varargin{:});
else, MI = min(varargin{:});
end
if nargout>3,
   [MA, IMA] = max(varargin{:});
else, MA = max(varargin{:});
end





