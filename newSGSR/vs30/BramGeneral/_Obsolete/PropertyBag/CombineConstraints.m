function S = CombineConstraints(S)
%COMBINECONSTRAINTS   combine constraints.
%   COMBINECONSTRAINTS(S)
%   COMBINECONSTRAINTS(Fnc)
%
%   Attention! This function is an internal function belonging to the  
%   property bag object and should not be invoked from the MATLAB
%   command prompt.

%B. Van de Sande 14-05-2004

%When constraints are specified by a structure-array multiple entries
%for the same class are combined to a single entry in the array ...
if isstruct(S) & (length(S) > 1),
    idx = find(strcmpi({S.class}, 'char') & ~cellfun('isempty', {S.range}));
    if ~isempty(idx),
        S(min(idx)).class      = 'char';
        S(min(idx)).dimensions = [];
        S(min(idx)).range      = unique(cat(2, S(idx).range));
        S(setdiff(idx, min(idx))) = [];
    end
end