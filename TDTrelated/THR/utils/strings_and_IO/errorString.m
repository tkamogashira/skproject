function mess = errorString(mess);
% errorString - convert char array or cell string to newline-delimited char string.
%     errorString(S), where S is a char array or cell array of strings, converts S
%     to a 1-row char string whose lines are seperated by newlines char(10).
%     The latter format is suitable as argument to error.
%
%     NOTE: this fnc may be obsolete due to Matlab's revision of ERROR.
%
%     See also cellstr, error.

NWL = char(10);
mess = cellstr(mess); 
% make sure mess is row vector of cells
mess = reshape(mess, [1 numel(mess)]);
%interleave newlies, reshape, remove last newline
newlines = repmat({NWL}, size(mess)); 
mess = [mess; newlines];
mess = [mess{:}];
mess = mess(1:end-1);








