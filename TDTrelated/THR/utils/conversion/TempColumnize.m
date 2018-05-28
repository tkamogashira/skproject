function [X, isRow] = TempColumnize(X);
% TempColumnize - temporary reshaping into column
%    [X, isRow] = TempColumnize(X) transposes X and returns isRow=true
%    only in case X is a row vector. All other cases leave X unaffected and
%    give isRow=false.
%
%    See also SameSize, Columnize.

isRow = isvector(X) && size(X,2)>1;
if isRow,
    X = X.';
end




