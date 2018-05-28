function [H, FNS] = tree2hedge(T)
% struct/tree2hedge - flatten a struct tree
%    H = tree2hedge(T), where T is a struct array, returns a struct array H 
%    in which any struct-valued fields (branches) are replaced by their fields.
%    This is done recursively, so that any tree-like structure is flattened
%    and a struct is built with no struct-valued fields and whose fields
%    are the leafs of the original tree (hence the name tree2hedge).
%    It is okay for T to have multiple elements, but any struct-valued
%    fileds must be scalars.
%
%    If duplicate fieldnames are encountered in the process, those visited
%    later will override the earlier ones. The order of visits is
%    determined by the order of the fieldnames. If a struct array of
%    length>1 is encountered during the process, an error results.
%    Empty structs are treated as [].
%
%    [H, Dup] = tree2hedge(T) also returns the duplicate fieldnames (if
%    any) in a cell array of strings.
%
%    Example:
%       T.branch1 = struct('leaveA', 1, 'leaveB', 2);
%       T.branch2 = struct('leaveB', 22, 'leaveC', 33);
%       tree2hedge(T)
%       ans = 
%          leaveA: 1
%          leaveB: 22
%          leaveC: 33
%
%    See also structpart

for ii=1:numel(T),
    [H(ii), FNS] = localFlatten(T(ii), {});
end
H = reshape(H,size(T));
FNS = unique(FNS);

% ----------
function [TT, FNS] = localFlatten(T, FNS);
% recursively replace the leaves from the branches to the stem
% FNS is the collection of LEAF fieldnames, whose duplicates matter.
SizeMess = 'Struct array with more than a single element encountered.'; 
TT = struct([]); 
Value = struct2cell(T);
Name = fieldnames(T);
for ii=1:length(Name),
    N = Name{ii};
    V = Value{ii};
    if isstruct(V),
        if numel(V)>1, error(SizeMess); end
        if ~isempty(V),
            [V, FNS] = localFlatten(V, FNS);
            [TT, fns] = union(TT,V);
            FNS = {FNS{:} fns{:}};
        end
    else,
        if ismember(N, fieldnames(TT)), FNS = [FNS N]; end
        eval(['TT(1).' N '= V;']);
    end
end





