function P = tprod(A,B)
% tprod - tensor product
%    P=tprod(A,B), where A and B ndims(A)==M and ndims(B)==N, is an 
%    (M+N-2)-dimensional array obtained by contraction of the last
%    dimension of A and the first dimension of B: 
%    P(i,j,...k,m,...) = Sum_n A(i,j,..,n)*B(n,k,m,..).
%    The inner dimensions of A and B (indexed by subscript n) must match.
%
%    See also times.

Sa = size(A);
Sb = size(B);

if Sa(end)~=Sb(1),
    error('Inner dimension mismatch in tensor product.');
end

% the trick is to temporary collapse the outer dimensions onto one grand
% dimension, perform ordinary matrix multiplication, and re-expand the
% outer dimensions.
OuterA = Sa(1:end-1);
OuterB = Sb(2:end)
A = reshape(A,prod(OuterA),Sa(end));
B = reshape(B,Sb(1), prod(OuterB));
P = A*B;
P = reshape(P, [OuterA, OuterB]);



