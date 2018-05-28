function ib = betwixt(X, A, B);
% BETWIXT - test if value is between two given values
%    BETWIXT(X,A,B) of BETWIXT(X, [A B]) returns true for those elements X(k) of X 
%    for which A<X(k)<B.

if nargin<3,
   B = A(:,end);
   A = A(:,1);
end

ib = (X>A) & (X<B);