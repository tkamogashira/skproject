function [x, ii, varargout] = denan(x, varargin)
% DENAN - remove NaNs from array
%   DENAN(X) returns only those elements of X 
%   that are not NaNs.
%   [Y, I] = DENAN(X) also returns an index vector I
%   such that Y = X(I).
%
%   [Y, I, Z, ..] = DENAN(X, Z, ..) also restricts the
%   additional vectors Z, .. to Z(I), ...
%
%   Note: is X is a matrix containing NaNs, then
%   DENAN(X) will be a row vector.

ii=find(~isnan(x));
x = x(ii);
for iarg=2:nargin,
   varargout{iarg-1} = varargin{iarg-1}(ii);
end



