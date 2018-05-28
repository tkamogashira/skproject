function s = IndentStr(s, N, ch);
% INDENTSTR - prepend whitespace to char matrix or cellstr
%    IndentStr(s, N) prepends N spaces to s.
%    for empty s, blanks(N) is returned.
%
%    IndentStr(s, N, ch), where ch is a character string
%    prepends N column of ch's. 

if nargin<3, ch = ' '; end;

CS = iscellstr(s); 
s = char(s);
if isempty(s),
   s = repmat(ch,1,0);
end
s = [repmat(ch, size(s,1), N) s];
if CS, s = cellstr(s); end
