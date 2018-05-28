function boolean = FindPattern(Col, Pattern)
%FINDPATTERN    STRUCTTOOLS utility.
%   To find a pattern in a field with all alphanumerical elements use the command
%   FINDPATTERN, which has the following syntax:
%                        FINDPATTERN($FieldName$, Pattern)
%   Pattern matching is case-insensitive.
%
%   Additional tools that can be used for expressions are GETCOLUMN and FINDELEMENT.

%B. Van de Sande 21-05-2005

%Column should always be a cell-array of strings, Pattern should always
%be a character string ...
if (nargin ~= 2) | ~iscellstr(Col) | ~ischar(Pattern), error('Wrong syntax for FINDPATTERN.'); end

%Use STRFINDCELL.M ...
idx = strfindcell(lower(Col), lower(Pattern));
boolean = ismember(1:length(Col), idx);
