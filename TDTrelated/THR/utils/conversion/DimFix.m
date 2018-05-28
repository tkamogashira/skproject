function V = DimFix(V, Dim);
% DimFix - clone elements of a single vector in order to comply with DimSpec
%    X = dimCheck(X, Dim) repairs a mismatch in sizes of the kind
%            A(1:4) = 7
%    and fixes it. That is, if at call time X is a single-element value
%    Dim equals [N N], then the return value is repmat(X,1,N).
%    If the above situation does not apply at call time, V is left unaffected
%
%    See also dimensionTest, isFixedDimSpec, Parameter/dimCheck.

if isFixedDimSpec(Dim, 'nonempty') & isequal(1, numel(V)),
    V = repmat(V,1,Dim(1));
end






