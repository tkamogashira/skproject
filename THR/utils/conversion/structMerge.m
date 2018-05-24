function M = structMerge(keyField, S,T,varargin);
% structMerge - merge struct arrays based on key field
%   M = structMerge('Foo', S,T) is a struct M that combines the fields of 
%   struct arrays S and T. The corresponding elements of S and T are found 
%   by their matching values of key fields S.Foo T.Foo. Any elements S(k)
%   that has no partner in T (i.e. some T(m) with S(k)==T(m)) will not end
%   up in M. The same is true for elements of T that have no partner in S.
%   If S and T have more fields in common than Foo, their values will be
%   taken from T. If not all key-field values S(k).Foo are unique, an error
%   results. The same goes for T. The values of Foo in both S and T must be
%   either numbers or char strings.
%   
%   structMerge('Foo', S,T, U,..) merges multiple structs. In case of
%   fieldnames occurring in multiple input structs, the last input arg
%   wins.
%
%   See also structJoin, CollectInStruct ,CombineStruct.

if nargin>3, % left-right recursion
    M = structMerge(keyField, S,T);
    M = structMerge(keyField, M, varargin{:});
    return;
end

% ======only two struct arrays, S & T==========
kvS = {S(:).(keyField)};
if ~ischar(kvS), kvS = cell2mat(kvS); end
kvSu = unique(kvS);
if numel(kvSu)<numel(kvS),
    error('Key field values of all elements of S must be unique.');
end
kvT = {S(:).(keyField)};
if ~ischar(kvT), kvT = cell2mat(kvT); end
kvTu = unique(kvT);
if numel(kvTu)<numel(kvT),
    error('Key field values of all elements of T must be unique.');
end
[dum, iS, iT] = intersect(kvS, kvT);

% now that we know the matching elements, delegate to structJoin
M = structJoin(S(iS), T(iT));







