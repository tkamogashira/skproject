function S = fulldeblank(S)
%FULLDEBLANK remove all blanks.
%   FULLDEBLANK(S) removes all blanks from string or cell-array of strings S.

%B. Van de Sande 16-07-2003

if ~isempty(S)
   if ischar(S), idx = find(isspace(S)); S(idx) = [];
   elseif iscellstr(S),
       for i = 1:prod(size(S)), S{i} = fulldeblank(S{i}); end
   else, error('Input must be a string'); end    
end