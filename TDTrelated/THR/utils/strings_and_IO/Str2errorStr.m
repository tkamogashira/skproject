function s = Str2errorStr(s);
% Str2errorStr - convert string matrix or cellstring to single string with <CR>s
%   Str2errorStr(s) converts string matrix or cellstring S to single string
%   with <CR>s, char(13).

CR = char(13);

s = char(s)'; % convert to string matrix which reads like a chinese newspaper
s = [s; repmat(CR,1, size(s,2))]; % append single row of CRs
s = s(:)'; % re-orient

