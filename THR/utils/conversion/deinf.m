function [x, ii, varargout] = denan(x, varargin);
% denan - remove inf from array
%   deinf(X) returns only those elements of X 
%   that are not inf.
%   [Y, I] = deinf(X) also returns an index vector I
%   such that Y = X(I).
%
%   [Y, I, Z, ..] = deinf(X, Z, ..) also restricts the
%   additional vectors Z, .. to Z(I), ...
%
%   Note: is X is a matrix containing NaNs, then
%   deinf(X) will be a row vector.
%
%   See also deinf.

ii=find(~isinf(x));
x = x(ii);
for iarg=2:nargin,
   varargout{iarg-1} = varargin{iarg-1}(ii);
end



