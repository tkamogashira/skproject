function d = NDiff(x, N);
% NDIFF - differences of vector elements that are N places apart
%   Ndiff(X, N) for a vector X is the vector with elements 
%       X(N+1)-X(1), X(M+2)-X(2),  ... X(L)-X(L-N),
%   where L=length(X).
%
%   For matrices, Ndiff operates in a column-wise fashion:
%      Ndiff(X, N) = [Ndiff(X(:,1), N),  Ndiff(X(:,2), N) ..].
%
%   See also DIFF.

if nargin<2, N = 1; end

if ~any(size(x)==1), % matrix: column-wise recursion
   d = [];
   for ii=1:size(x,2),
      d = [d, NDiff(x(:,ii))];
   end
   return;
end

% x is vector from here. Simple as pi.
d = x(N+1:end)-x(1:end-N);

