function s = strSubst(s,ss1,ss2, lastOneOnly)
% strSubst - replace all occurrences of a substring by another substring
%   strSubst(S, oldToken, newToken) replaces all occurrences string S
%   of oldToken by newToken. 
%   The lengths of oldToken & newToken need not match.
%
%   strSubst(S, oldToken, newToken, 1) replaces only the *last*
%   occurrence of oldToken.


if nargin<4, lastOneOnly=0; end

if iscellstr(s), % recursively, elementwise
   for ii=1:length(s),
      s{ii} = strSubst(s{ii}, ss1, ss2, lastOneOnly);
   end
   return;
end

if length(s)<length(ss1), return; end; % findstr is symmetric in its args; avoid confusion
N1 = length(ss1);
II = fliplr(findstr(s, ss1)); % occurrences of ss1 within s from right to left
if isempty(II), return; end;
if lastOneOnly, II=II(1); end;

for ii=II,
   tailstart = ii+N1;
   s = [s(1:ii-1) ss2 s(tailstart:end)];
end




