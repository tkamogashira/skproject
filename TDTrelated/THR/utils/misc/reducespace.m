function [Vr, R] = reducespace(V, tol);
% reducespace - reduce set of vectors to an independent set
%   Vr=reducespace(V), where V is an m-by-n matrix, returns a m-by-rank(V)
%   matrix Vr whose columns span the same linear space as the columns of V.
%   The columns of Vr are orthonormal, i.e., Vr'*Vr = eye(rank(V))
%   
%   [Vr R] = reducespace(V) also returns a rank(V)-by-n matrix R such 
%   that V = Vr*R.
%
%   See also QR, RANK, intersectspace, nulltol.

tol = arginDefaults('tol', 1e-6);

Rk = rank(V, tol);
[U1 D U2] = svd(V);
W = abs(diag(D)); 
[dum, isort] = sort(W, 'descend');
ired = isort(1:Rk); 
D = D(ired,ired);
U2 = U2(:,ired);
R = D*U2';
Vr = U1(:,ired);






