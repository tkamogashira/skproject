function Tokens = parseStr(Line, Sep)
%PARSESTR parse character string
%   T = PARSESTR(S, Sep) parses character string S into tokens, returned as a cell-array of strings T. Optional
%   argument Sep can be given to specify the separator to be used. The default separator is TAB.

%B. Van de Sande 22-07-2003

if nargin == 1, Sep = char(9); end %TAB

L = length(Line);
idx = [0 findstr(Line, Sep) L+1];
N = length(idx) - 1;
Tokens = cell(1, N);

idx_start = idx(1:end-1) + 1;
idx_end   = idx(2:end) - 1;

for n = 1:N, Tokens{n} = cleanStr(Line(idx_start(n):idx_end(n))); end
