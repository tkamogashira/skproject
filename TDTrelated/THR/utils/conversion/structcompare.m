function [Sd, Td] = structCompare(S,T);
% structCompare - compare two structs
%   [Sd, Td]=structCompare(S,T) evaluates how S and T differ.
%    Sd is S restricted to those fields that are different or absent in T.
%    Td is T restricted to those fields that are different or absent in S.
%
%   See also StructPart.

FS = fieldnames(S);

for ii=1:numel(FS),
    fs = FS{ii};
    if isfield(T,fs) && isequalwithequalnans(S.(fs), T.(fs)), % equal - no action
    else,
        Sd.(fs) = S.(fs);
    end
end

FT = fieldnames(T);
for ii=1:numel(FT),
    ft = FT{ii};
    if isfield(S,ft) && isequalwithequalnans(S.(ft), T.(ft)), % equal - no action
    else,
        Td.(ft) = T.(ft);
    end
end

if ~exist('Sd', 'var'), Sd = []; end
if ~exist('Td', 'var'), Td = []; end












