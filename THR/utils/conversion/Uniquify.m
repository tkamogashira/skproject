function X = Uniquify(X);
% Uniquify - reduce vector to scalar if all elements are equal
%   Uniquify(X) for vectors, returns X(1) if all elements
%   of X are equal, or the unchanged X otherwise.
%
%   For matrices, Uniquify(M) returns the row vector
%   M(1,:) if all columns of M consist of a repeated value,
%   or the unchanged M otherwise.
%
%   By convention, empty values are returned unchanged.
%
%   See unique.

if isempty(X), return; end
[height, width] = size(X);
if (height==1) || (width==1), % vector
   if all(X==X(1)), X = X(1); end
else, % matrix
   if isequal(X, repmat(X(1,:), height, 1)),
      X = X(1,:);
   end
end




