function NV = normalvector(X);
% normalvector - normal of N-1 vectors of length N
%    normalvector(X), where X is N x (N-1), returns the normal of the space
%    spanned by the columns of X. This is a generalization of the cross
%    product. Normalvector(X) is parallel to null(X.').', but the latter is
%    not properly normalized.
%
%    if X is N x N, the last column of X is taken as the "origin", i.e.,
%    normalvector(X(:,1:end-1)-X(:,end)) is returned.
%
%    See also NULL.

% normal of N-1 N-dim vectors
Ndim = size(X,1);
if isequal(Ndim, size(X,2)), % last column is "origin"; see help text
    X = bsxfun(@minus, X(:,1:end-1), X(:,end));
end
if ~isequal(Ndim-1, size(X,2)),
    error('X must be N by N-1 or N by N matrix.');
end
E0 = [1; zeros(Ndim-1,1)];
NV = zeros(Ndim,1);
for ii=1:Ndim,
    Eii = circshift(E0, ii-1);
    NV(ii) = det([Eii X]);
end














