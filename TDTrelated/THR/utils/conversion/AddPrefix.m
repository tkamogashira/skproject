function T = AddPrefix(S, Prefix, L);
% AddPrefix - insert prefix into field names of struct
%    S = AddPrefix(S, 'Foo') changes fieldnames 'Field' of S into
%    'FooField'.
%
%    S = AddPrefix(S, 'Foo', List) only changes the fieldnames listed in
%    cell array List.
%
%    See also DePrefix.

if nargin<3,
    L = [];
end
T = repmat(struct, size(S));
if isempty(L), % default: all fieldnames
    L = fieldnames(S);
end

FNS = fieldnames(S);
for ii=1:numel(FNS),
    fn = FNS{ii};
    if ismember(fn, L),
        new_fn = [Prefix fn];
    else,
        new_fn = fn;
    end
    [T.(new_fn)] = deal(S.(fn));
end


