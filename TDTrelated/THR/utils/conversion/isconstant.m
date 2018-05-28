function c = isconstant(X, Dim);
% isConstant - test whether all elements of array are equal
%    isConstant(X) returns 1 if all elements of X are equal, zero
%    otherwise. For a matrices, isConstant tests the rows of X and
%    returns a row vector R(k) = isConstant(X(:,k)).
%    isConstant([]) equals [] by convention.
%
%    isConstant(X,Dim) tests constancy along dimension Dim. Default Dim=1.
%  
%    See also Minmax, isscalar, isvector.

if nargin<2, Dim=1; end

if isvector(X), X = X(:); end % avoid testing per "column"

MI = min(X,[],Dim);
MA = max(X,[],Dim);
c = (MI==MA);


