function [d, n] = cheapRat(x, tol);
% cheapRat - cheap version of RAT
%   [N,D] = cheapRat(X,tol) approximates X by D/N within tolerance X, that
%   is, abs(X-N/D),abs(X*tol). CheapRat uses RAT, but is cheaper than RAT
%   in that the tolerance is more closely met: D and N are generally
%   smaller than D and N returned by RAT.
%
%   See also RAT.
if ~isscalar(x),
    error('X argument must be scalar.')
end

[d n] = rat(x,tol);
for ii=1:10, 
    [dd nn] = rat(x,tol*2^ii); 
    realtol = abs(dd/nn-x)/abs(x);
    if realtol>tol, break; end % gone too far
    d = dd; n = nn;
end



