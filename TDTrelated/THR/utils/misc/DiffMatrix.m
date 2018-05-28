function DM = DiffMatrix(x,y);
% DiffMatrix - matrix of all differences of vector elements
%   DiffMatrix(X), where X is a N-vector, returns the skew
%   NxN matrix whose (i,j)-th element contains the difference X(i)-X(j).
%
%   M = DiffMatrix(X,Y) returns length(X)xlength(Y) matrix M
%   with M(i,j) == X(i)-Y(j)

if nargin<2, y = x; end;
if ~any(size(x)==1),
   error('Input argument X must be vector.');
elseif ~any(size(y)==1),
   error('Input argument Y must be vector.');
end
   
M = length(x); N = length(y);

DM = repmat(x(:), [1 N]) - repmat(y(:).', [M 1]);



