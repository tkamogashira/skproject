function S = structPart(T,FN);
% structPart - select subset of fields from struct
%   structPart(S,{'Foo1' 'Foo2' ...}) struct S restricted to fields Foo1,
%   Foo2, etc. S may be struct array.
%
%   structPart(S,{'Foo1' 'Foo2' '-' ...  '-' ...}) inserts separator
%   fields, that is, fake fields with names containing a lot of
%   underscores.
%
%   By convention structPart(S,{}) and structPart(S,'') return a struct
%   with no fields and having the same size as S.
%
%   See also struct/union, CombineStruct.

if isempty(FN),
    S = repmat(struct(), size(T)); 
    return;
end
FN = cellify(FN);
isep = 1;
for ii=1:numel(FN),
    fn = FN{ii};
    if isequal('-', fn),
        StrArg{1,ii} = structseparator(isep);
        StrArg{2,ii} = '________________';
        isep = isep+1;
    else,
        StrArg{1,ii} = fn;
        StrArg{2,ii} = {T.(fn)};
    end
end
[dum, idim] = max(size(T));
S = struct(StrArg{:});
S = reshape(S,size(T));





