function S = structFlatten(S);
% structFlatten - flatten struct by expanding any struct-valued fields
%   structFlatten(S) replaces any struct-valued fields of struct S by new
%   fiels in S. The new fieldnames are obtained by combining the fieldnames
%   using underscores. For example, if originally the field S.foo.a exists,
%   then after the conversion its value is stored in S.foo_a. structFlatten
%   works recursely, e.g. S.aa.bb.cc becomes S.aa_bb_cc.
%
%   S may be an array, but then it is tacidly assumed that all values
%   of a given field are either struct-valued, or all are non-struct
%   valued. That is, if S(1).foo is a struct, then all S(k) must be
%   structs. Moreover, all structs S9K).foo must have the same fields.
%
%   See also structjoin.

if isempty(S), return; end

% which fields are struct-valued
FN = fieldnames(S);
FV = struct2cell(S(1));
i_struct = cellfun(@isstruct, FV);
if isempty(i_struct),
    return;
end

% --so  S does have struct-value fieldnames: flatten them
T = repmat(rmfield(struct('a',0),'a'),size(S)); % T is struct with no fields but csame size as S
for ii=1:numel(FN),
    fn = FN{ii};
    if ~isstruct(S(1).(fn)), % just copy
        [T.(fn)] = deal(S.(fn)); % need to deal in case of array S
    else, % S.fv is/are struct
        fv = structFlatten([S.(fn)]); % recursion: S.fv may contain struct-valued fields, etc
        FFN = fieldnames(fv);
        FFV = struct2cell(fv);
        for jj=1:numel(FFN),
            ffn = [fn '_' FFN{jj}]; % name of new field
            [T.(ffn)] = deal(FFV{jj,:});
        end
    end
end
S = T;  




