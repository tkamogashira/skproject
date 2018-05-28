function [x, inear] = NthFloor(X,Xfloor);
% NthFloor - downward rounding to given set of values
%    NthFloor(X,Xfloor) returns the largest element Xfloor(k) <= X.
%    X may be array, in which case each element of X is rounded towards its
%    own Xfloor element. Xfloor must be increasing. Elements of X smaller
%    than Xfloor(1) yield -inf.
%
%    [Xdown, I] = NthFloor(X,Xfloor) also returns an index array I such
%    that Xdown = Xfloor(I), with the exception of elements of X smaller 
%    than Xfloor(1), whose indices are zero.
%
%    See also FLOOR.
DX = diff(Xfloor); 
if any(DX<=0), error('Xfloor must be monotonically increasing.'); end

% 
Xfloor = [-inf Xfloor(:).' inf];
N = numel(Xfloor);
% first round to nearest element of Xfloor, using indices
inear = interp1(Xfloor, 1:N, X, 'nearest');
inear(inear==N) = N-1; % even X=inf should be rounded down to max(Xfloor)
iup = (Xfloor(inear)>X); % indices of upward-rounded X
inear(iup) = inear(iup)-1; % force those to be rounded downward after all
x = Xfloor(inear);
inear = inear-1;





