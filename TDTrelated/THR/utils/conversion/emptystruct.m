function S = emptystruct(varargin);
% emptystruct - 0x0 sized struct with given field names.
%   S('foo', 'abc', ...) is a 0x0 sized struct with fields foo, abc, ...
%
%   See also voidstruct.

c = cell(size(varargin));
S = cell2struct(c,varargin,2);
S = S([]);


