function [xm, ym, varargout] = maxloc(X,Y, varargin);
% MAXLOC - return x-value at maximum of Yvalue
%   MAXLOC(X,Y) returns X(I), where Y(I) == max(Y)
%   X and Y must have equal number of rows.
%
%   [XM, YM] = MAXLOC(X,Y) also returns the maximum Y value itself.
%
%   [XM, YM, ZM, ..] = MAXLOC(X,Y,Z,..) also returns the Z, .. values at
%   the maximum.
%
%   See also MINLOC, MAX.

if ~isequal(size(X,1), size(Y,1)), error('X and Y must have equal # rows'); end
[ym, I] = max(Y);
xm = X(I);
xm = xm(:).'; % must be row vector
for ii=3:nargin,
   z = varargin{ii-2};
   z = z(:);
   varargout{ii-2} = z(I);
end

