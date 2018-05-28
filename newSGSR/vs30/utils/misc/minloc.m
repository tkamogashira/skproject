function [xm, ym, varargout] = minloc(X,Y, varargin);
% MINLOC - return x-value at minimum of Yvalue
%   MINLOC(X,Y) returns X(I), where Y(I) == min(Y)
%   X and Y must have equal number of rows.
%
%   [XM, YM] = MINLOC(X,Y) also returns the minimum Y value itself.
%
%   [XM, YM, ZM, ..] = MINLOC(X,Y,Z,..) also returns the Z, .. values at
%   the minimum.
%
%   See also MAXLOC, MIN.

if ~isequal(size(X,1), size(Y,1)), error('X and Y must have equal # rows'); end
[ym, I] = min(Y);
xm = X(I);
xm = xm(:).'; % must be row vector
for ii=3:nargin,
   z = varargin{ii-2};
   z = z(:);
   varargout{ii-2} = z(I);
end
