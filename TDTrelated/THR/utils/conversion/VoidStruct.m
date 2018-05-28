function V = VoidStruct(varargin)
% VoidStruct - structure with all empty fields
%   VoidStruct('field1', 'field2', ...) is a struct with fields named
%   field1, field2, ... and all fields equal to [].
%   Any '-' among the fieldnames will be replaced by 'a_________', etc.
%
%   An alternative syntax is:
%   VoidStruct('field1/field2/...')
%
%   See also structPart, CollectInStruct, structseparator, emptystruct.

if nargin==0,
    V = struct([]);
    return;
end

Arg = varargin;
% parse 'f1/f2/...' syntax
if nargin==1,
    if ~isempty(strfind(Arg{1}, '/')),
        Arg = words2cell(Arg{1}, '/');
    end
end
idash = strmatch('-', Arg);
for isep=1:numel(idash),
    Arg{idash(isep)} = structseparator(isep);
end
Nfields = length(Arg);
V = cell2struct(cell(1,Nfields), Arg,2);


