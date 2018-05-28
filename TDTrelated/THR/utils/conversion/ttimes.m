function C = ttimes(A,B)
% ttimes - contraction of multidim arrays ("tensor product")
%    X = ttimes(A,B), where A and B are multidimensional arrays is the
%    tensor contraction of the A and B:
%
%       X(i1,i2...in, j1, j2, ...) = Sum A(i1,i2,..,in,k)*B(k,j1,j2,..)
%                                     k
%    This is a generalization of the ordinary matrix multiplication.
%
%    See also MTIMES.

sA = size(A);
sB = size(B);
if ~isequal(sA(end), sB(1)),
    error('Inner dimension mismatch.');
end
% idea: pack the fixed dimensions of A & B, call mtimes, unpack (reshape)
sC = [sA(1:end-1) sB(2:end)];
A = reshape(A, [prod(sA(1:end-1)) sA(end)]);
B = reshape(B, [sB(1) prod(sB(2:end))]);
C = reshape(A*B, sC);




