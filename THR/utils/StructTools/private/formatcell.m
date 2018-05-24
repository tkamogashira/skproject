function S = formatcell(C, Enc, Sep)
%FORMATCELL format a string-cellarray containing dsIDs
%   S = FORMATCELL(C) formats the cell-array of strings C to the character string S, with each item of C enclosed
%   between '<' and '>' and separated by ','.
%
%   S = FORMATCELL(C, Enc, Sep) the same as before but the characters wich enclose the cell-array items is given
%   by the 2-element cell-array Enc. The seperator is given by the character string Sep.

%B. Van de Sande  25-07-2003

if ~any(nargin == [1,3]), error('Wrong number of input arguments.'); end
if ~iscellstr(C), error('First argument should be cell-array of strings.'); end

if nargin == 1
    Enc = {'<', '>'};
    Sep = ',';
end

C = C(:); NElem = length(C);

C = cat(2, repmat(Enc(1), NElem, 1), C, repmat(Enc(2), NElem, 1), repmat({Sep}, NElem, 1))';
S = sprintf('%s', C{:}); 
if ~isempty(S), S(end) = []; end