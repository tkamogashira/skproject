function varargout = nthCol(varargin);
% NTHCOL(X) - Nth column if it exists
%   NthCol(X,N) is the Nth column of X is it exists, the
%   last column otherwise
%
%   [Xn Yn ..] = NthCol(X, Y, ..,N) can be used to extract the
%   columns variable-wise.
%
%   See also NthElement


if nargin~=(nargout+1),
   error('Nargin must equal nargout + 1.');
end

n = varargin{nargin};
if nargin>2, % recursive call
   for ii=1:nargin,
      varargout{ii} = nthcol(varargin{ii},n);
   end
   return;
end
% single elem from here
x = varargin{1};
ic = min(size(x,2),n);
varargout = {x(ic)};

