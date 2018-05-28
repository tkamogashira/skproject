function Str = cellstr2str(C, Sep, Prefix, Suffix)
%CELLSTR2STR    convert cellarray of strings to character string.
%   S = CELLSTR2STR(C) converts the cell-array of strings C
%   to the character string S, with each string in C separated
%   by a comma.
%   S = CELLSTR2STR(C, Sep) the same as before but the separator
%   is given by the character string Sep. 
%   S = CELLSTR2STR(C, Sep, Prefix, Suffix) each string has an extra
%   prefix and suffix concatenated.

%B. Van de Sande  28-06-2004

%Checking input arguments ...
if ~any(nargin == 1:4), error('Wrong number of input arguments.'); end
if ~iscellstr(C), error('First argument should be cell-array of strings.'); end
switch nargin
case 1, [Sep, Prefix, Suffix] = deal(',', '', '');
case 2, [Prefix, Suffix] = deal('');
case 3, Suffix = ''; end    
if ~ischar(Sep) | ~ischar(Prefix) | ~ischar(Suffix), 
    error('Separator, prefixes and suffixes must be supplied as character strings.'); 
end

C = C(:); N = length(C);
C = cat(2, repmat({Prefix}, N, 1), C, repmat({Suffix}, N, 1), repmat({Sep}, N, 1))';
Str = cat(2, C{:}); 
if ~isempty(Str), Str(end-[0:(length(Sep)-1)]) = []; end %Remove last separator ...