function varargout = DealElements(X);
% DealElements - deal the elements of an array over different variables.
%   [A,B, ..] = DealElements(X) is the same as the combination of assigments
%       A = X(1)
%       B = X(2)
%       ...
%
%    The number of output arguments must match the number of elements in
%    array X. Note that DealElements is in fact the inverse operation of
%    CAT.
%
%    See also DEAL, CAT.

if ~isequal(nargout, numel(X)),
    error('# output args must match #elements of single input X.');
end

if isnumeric(X) || islogical(X),
    varargout = num2cell(X);
else, % primitive loop
    for ii=1:numel(X),
        varargout{ii} = X(ii);
    end
end


