function Str = cellstr2char10str(C);
% cellstr2char10str - convert cellstring to char(10)-deleimted string
%   cell2chararray(C) returns a single char string in which the elements of
%   C are concatenated, using char(10) as a seperator. This creates
%   multiline strings that can be passed to ERROR, used as tooltips of
%   uicontrols, etc.
%
%   See also prettyprint, cell2chararray.

Str = '';
if numel(C)>0,
    for ii=1:numel(C)-1,
        Str = [Str, C{ii}, char(10)];
    end
    Str = [Str, C{end}];
end

