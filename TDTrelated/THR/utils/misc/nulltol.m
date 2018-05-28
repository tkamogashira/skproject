function [N, R] = nulltol(V, tol);
% nulltol - null space of a matrix evaluated using a tolerance
%   N = nulltol(V, tol), where V is an m-by-n matrix, returns a
%   m-by-(n-rank(V)) matrix N whose columns span the null space of V,
%   computed using a tolerance tol.
%
%   [N R] = nulltol(V, tol) also returns a "residu matrix" R which idellay
%   equals zero.
%   
%   See also QR, RANK, intersectspace, reducespace, intersectspace.

tol = arginDefaults('tol', 1e-6);

Rk = rank(V, tol);
N = size(V,2);
[U1 D U2] = svd(V);
W = abs(diag(D)); 
[dum, isort] = sort(W, 'ascend');
ired = isort(1:(N-Rk)); % select the smallest (ideally, negligeable) singular values
D = D(ired,ired);
U2 = U2(:,ired);
R = D*U2';
N = U1(:,ired);






